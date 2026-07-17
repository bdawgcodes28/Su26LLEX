// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module user_project_wrapper #(
    parameter BITS = 32
) (

`ifdef USE_POWER_PINS
    inout vdda1,
    inout vdda2,
    inout vssa1,
    inout vssa2,
    inout vccd1,
    inout vccd2,
    inout vssd1,
    inout vssd2,
`endif

    // Wishbone interface
    input         wb_clk_i,
    input         wb_rst_i,
    input         wbs_stb_i,
    input         wbs_cyc_i,
    input         wbs_we_i,
    input  [3:0]  wbs_sel_i,
    input  [31:0] wbs_dat_i,
    input  [31:0] wbs_adr_i,
    output        wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // GPIO
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Analog GPIO
    inout [`MPRJ_IO_PADS-10:0] analog_io,

    // Independent user clock
    input user_clock2,

    // Interrupts
    output [2:0] user_irq
);

    // SRAM reset is active low.
    wire sram_rst_n;
    assign sram_rst_n = ~wb_rst_i;

    // ---------------------------------------------------------
    // Macro 0 control mapping
    // ---------------------------------------------------------

    wire        cs0;
    wire        we0;
    wire [7:0]  addr0;
    wire [7:0]  write_allow0;
    wire [63:0] datain0;
    wire [63:0] dataout0;

    assign cs0            = io_in[0];
    assign we0            = io_in[1];
    assign addr0          = io_in[9:2];
    assign write_allow0   = io_in[17:10];
    assign datain0        = la_data_in[63:0];

    // ---------------------------------------------------------
    // Macro 1 control mapping
    // ---------------------------------------------------------

    wire        cs1;
    wire        we1;
    wire [7:0]  addr1;
    wire [7:0]  write_allow1;
    wire [63:0] datain1;
    wire [63:0] dataout1;

    assign cs1            = io_in[18];
    assign we1            = io_in[19];
    assign addr1          = io_in[27:20];
    assign write_allow1   = io_in[35:28];
    assign datain1        = la_data_in[127:64];

    // ---------------------------------------------------------
    // Hardened SRAM macro instances
    // ---------------------------------------------------------

    test_sram_macro macro0 (
        .rst_n       (sram_rst_n),
        .clk         (wb_clk_i),
        .cs          (cs0),
        .we          (we0),
        .addr        (addr0),
        .write_allow (write_allow0),
        .datain      (datain0),
        .dataout     (dataout0)
    );

    test_sram_macro macro1 (
        .rst_n       (sram_rst_n),
        .clk         (wb_clk_i),
        .cs          (cs1),
        .we          (we1),
        .addr        (addr1),
        .write_allow (write_allow1),
        .datain      (datain1),
        .dataout     (dataout1)
    );

    // Return SRAM read data through the logic analyzer.
    assign la_data_out[63:0]   = dataout0;
    assign la_data_out[127:64] = dataout1;

    // Wishbone is unused in this simple implementation.
    assign wbs_ack_o = 1'b0;
    assign wbs_dat_o = 32'b0;

    // GPIOs are used only as inputs here.
    assign io_out = {`MPRJ_IO_PADS{1'b0}};
    assign io_oeb = {`MPRJ_IO_PADS{1'b1}};

    // No interrupts are generated.
    assign user_irq = 3'b000;

endmodule

`default_nettype wire
