`default_nettype none

(*blackbox*)
module test_sram_macro(
    input rst_n,
    input clk,
    input cs,
    input we,
    input [7:0] addr,
    input [7:0] write_allow,
    input [63:0] datain,
    output [63:0] dataout
);
endmodule

`default_nettype wire
