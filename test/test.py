# SPDX-FileCopyrightText: © 2024 Finley Morris
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # set up a clock (10 microsecond period)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # reset the chip
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0          # press reset (active low)
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1          # release reset
    await ClockCycles(dut.clk, 1)

    # after reset, the counter should be 0
    dut._log.info("Check it starts at 0")
    assert dut.uo_out.value == 0

    # let 10 clock ticks pass, then the counter should read 10
    dut._log.info("Check it counts to 10")
    await ClockCycles(dut.clk, 10)
    assert dut.uo_out.value == 10

    dut._log.info("Counter works!")
