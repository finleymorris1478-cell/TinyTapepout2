/*
 * Copyright (c) 2024 Finley Morris
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // --- the slow tick generator ---
  // a big 24-bit box that counts fast clock ticks
  reg [23:0] divider;

  always @(posedge clk) begin
    if (!rst_n)
      divider <= 0;
    else
      divider <= divider + 1;
  end

  // this is 1 for a single fast tick, each time the divider rolls over
 wire slow_tick = ui_in[0] ? (divider[1:0] == 0) : (divider == 0);
    
  // --- your visible counter ---
  reg [7:0] count;

  always @(posedge clk) begin
    if (!rst_n)
      count <= 0;
    else if (slow_tick)        // only step forward on the slow tick
      count <= count + 1;
  end

  // send the visible count to the 8 LED pins
  assign uo_out  = count;

  // unused bidirectional pins, switched off
  assign uio_out = 0;
  assign uio_oe  = 0;

  // tell the tools we're deliberately not using these
  wire _unused = &{ena, ui_in, uio_in, 1'b0};

endmodule
