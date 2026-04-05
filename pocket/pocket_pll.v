// pocket_pll.v — Bally Astrocade PLL for Analogue Pocket
//
// Input: 74.25 MHz
// Outputs:
//   outclk_0: 14.31818 MHz  (clk_sys — system clock)
//   outclk_1: 14.31818 MHz  (clk_vid — video output clock)
//   outclk_2: 14.31818 MHz  (clk_vid_90 — video output clock 90° for DDR)

`timescale 1 ps / 1 ps

module pll (
    input  wire        refclk,
    input  wire        rst,
    output wire        outclk_0,
    output wire        outclk_1,
    output wire        outclk_2,
    output wire        locked
);

altera_pll #(
    .fractional_vco_multiplier ("true"),
    .reference_clock_frequency ("74.25 MHz"),
    .operation_mode            ("direct"),
    .number_of_clocks          (3),
    .output_clock_frequency0   ("14.31818 MHz"),
    .phase_shift0              ("0 ps"),
    .duty_cycle0               (50),
    .output_clock_frequency1   ("14.31818 MHz"),
    .phase_shift1              ("0 ps"),
    .duty_cycle1               (50),
    .output_clock_frequency2   ("14.31818 MHz"),
    .phase_shift2              ("17458 ps"),
    .duty_cycle2               (50),
    .pll_type                  ("General"),
    .pll_subtype               ("General")
) pll_inst (
    .refclk   ({1'b0, refclk}),
    .rst      (rst),
    .outclk   ({outclk_2, outclk_1, outclk_0}),
    .locked   (locked),
    .fboutclk (),
    .fbclk    (1'b0),
    .reconfig_to_pll   (64'd0),
    .reconfig_from_pll ()
);

endmodule
