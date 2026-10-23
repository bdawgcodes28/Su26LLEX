(* blackbox *)
module inv_ring_osc (
`ifdef USE_POWER_PINS
    inout wire vccd1,
    inout wire vssd1,
`endif
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

endmodule
