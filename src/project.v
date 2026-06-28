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

  // a storage box that holds an 8-bit number (0 to 255)
  reg [7:0] count;

  // on every clock tick, do this:
  always @(posedge clk) begin
    if (!rst_n)        // if the reset button is pressed (signal is 0)...
      count <= 0;      // ...set the number back to 0
    else               // otherwise...
      count <= count + 1;  // ...add 1 to the number
  end

  // send the number out to the 8 LED pins
  assign uo_out  = count;

  // we're not using the bidirectional pins, so switch them off
  assign uio_out = 0;
  assign uio_oe  = 0;

  // tell the tools we're deliberately not using these (stops warnings)
  wire _unused = &{ena, ui_in, uio_in, 1'b0};

endmodule
