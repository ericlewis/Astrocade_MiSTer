#
# user core constraints
#
# put your clock groups in here as well as any net assignments
#

# Base clocks and derive_pll_clocks are created in apf_constraints.sdc.
derive_clock_uncertainty

set pll_core_clks [get_clocks {
    ic|pll_inst|pll_inst|general[0].gpll~PLL_OUTPUT_COUNTER|divclk
    ic|pll_inst|pll_inst|general[1].gpll~PLL_OUTPUT_COUNTER|divclk
    ic|pll_inst|pll_inst|general[2].gpll~PLL_OUTPUT_COUNTER|divclk
}]

set jtag_clk [get_clocks {altera_reserved_tck}]

if {[llength $jtag_clk] > 0} {
    set_clock_groups -asynchronous \
        -group [get_clocks {bridge_spiclk}] \
        -group [get_clocks {clk_74a}] \
        -group [get_clocks {clk_74b}] \
        -group $pll_core_clks \
        -group $jtag_clk
} else {
    set_clock_groups -asynchronous \
        -group [get_clocks {bridge_spiclk}] \
        -group [get_clocks {clk_74a}] \
        -group [get_clocks {clk_74b}] \
        -group $pll_core_clks
}
