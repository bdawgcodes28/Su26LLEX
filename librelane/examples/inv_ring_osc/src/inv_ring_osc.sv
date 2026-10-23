/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

// -------------------------------------------------------------------------------------------------|
// Below is the design for an inverter-based ring oscillator.          |
// Inverter-based ring oscillators are comprised of an odd CMOS number of                                                       |
// simple CMOS inverters connected in series with the output of the    |
// last inverter being connected to the input of the first. This series connection                                      |
// and the recycling of the final output creates a feedback loop and the oscillation effect.            |
// -------------------------------------------------------------------------------------------------|



// --------------------------------------------------------------------------------------|
// The following module describes a simple CMOS inverter (or NOT gate). |
// It features two ports, a logic input and a logic output. Each port is defaulted               |
// to one-bit wide. This is a simple combinational logic circuit, as it will always              |
// assign the output as the inverse of the gates input.                 |
// --------------------------------------------------------------------------------------|

module inverter (
        input logic in,
        output logic out
);

        always_comb begin
                out = ~in;
        end
endmodule


// -------------------------------------------------------------------|
// The following module describes an inverter-based ring oscillator   |
// containing seven (7) inverters connected in a feedback loop.          |
// -------------------------------------------------------------------|

module inv_ring_osc (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

  // oscillator enable signal
  assign osc_en = ui_in[0];

  // internal wires connecting inverters
  wire osc_en; // enable signal
  wire [6:0] inv_out;

  // Instantiate inverters to use in the ring oscillator

  assign inv_out[0] = ~(inv_out[6] & osc_en); // NAND gate connected in series with the remaining inverters

  inverter inv2 (.in(inv_out[0]), .out(inv_out[1]));
  inverter inv3 (.in(inv_out[1]), .out(inv_out[2]));
  inverter inv4 (.in(inv_out[2]), .out(inv_out[3]));
  inverter inv5 (.in(inv_out[3]), .out(inv_out[4]));
  inverter inv6 (.in(inv_out[4]), .out(inv_out[5]));
  inverter inv7 (.in(inv_out[5]), .out(inv_out[6]));

  // Ring oscillator outout assigned to bit 0 or uo_out
  assign uo_out[0] = inv_out[6];

  // Tie all unused output pins to 0
  assign uo_out [7:1] = 7'b0;
  assign uio_out = 8'b0;
  assign uio_oe = 8'b0;

endmodule
