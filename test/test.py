# SPDX-FileCopyrightText: © 2024 Finley Morris
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

    dut._log.info("Check it starts at 0")
    assert dut.uo_out.value == 0

    dut._log.info("Check it counts to 10")
    await ClockCycles(dut.clk, 10)
    assert dut.uo_out.value == 10

    dut._log.info("Counter works!")
