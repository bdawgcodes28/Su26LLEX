
`default_nettype none

// Multi-macro inverter-based ring oscillator
// Contains two independently enabled ring oscillators.

module inv_ring_osc_unwrapped (
    input  wire [1:0] osc_en,
    output wire [1:0] osc_out
);

    // Internal outputs from each oscillator
    wire [7:0] out0;
    wire [7:0] out1;

    // First hardened ring oscillator
    inv_ring_osc inv_ring_osc1 (
        .ui_in({7'b0, osc_en[0]}),
        .uo_out(out0),
        .uio_in(8'b0),
        .uio_out(),
        .uio_oe(),
        .ena(1'b1),
        .clk(1'b0),
        .rst_n(1'b1)
    );

    // Second hardened ring oscillator
    inv_ring_osc inv_ring_osc2 (
        .ui_in({7'b0, osc_en[1]}),
        .uo_out(out1),
        .uio_in(8'b0),
        .uio_out(),
        .uio_oe(),
        .ena(1'b1),
        .clk(1'b0),
        .rst_n(1'b1)
    );

    // Assign each oscillator output
    assign osc_out[0] = out0[0];
    assign osc_out[1] = out1[0];

endmodule


// Top-level module for LibreLane
module inv_ring_osc2 (
    input  wire [1:0] osc_en,
    output wire [1:0] osc_out
);

    inv_ring_osc_unwrapped submodule (.*);

endmodule

`default_nettype wire
