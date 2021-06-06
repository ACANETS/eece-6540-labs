set_max_skew -from [get_keepers {fpga_top|inst_blue_ccip_interface_reg|pck_cp2af_softReset_T0_q}] -to [get_pins {fpga_top|inst_green_bs|bsp_interface_inst|ddr4*_reset_sync|resync_chains[0].synchronizer_nocut|*|clrn}] -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.800 
set_max_delay -from [get_keepers {fpga_top|inst_blue_ccip_interface_reg|pck_cp2af_softReset_T0_q}] -to [get_pins {fpga_top|inst_green_bs|bsp_interface_inst|ddr4*_reset_sync|resync_chains[0].synchronizer_nocut|*|clrn}] 100.000
set_min_delay -from [get_keepers {fpga_top|inst_blue_ccip_interface_reg|pck_cp2af_softReset_T0_q}] -to [get_pins {fpga_top|inst_green_bs|bsp_interface_inst|ddr4*_reset_sync|resync_chains[0].synchronizer_nocut|*|clrn}] -100.000

# Reset is comes from the TCM during a BIP compile
set_max_skew -from [get_keepers {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|tcm_control_out|pio_0|data_out[0]}] -to [get_pins {fpga_top|inst_green_bs|bsp_interface_inst|ddr4*_reset_sync|resync_chains[0].synchronizer_nocut|*|clrn}] -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.800 
set_max_delay -from [get_keepers {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|tcm_control_out|pio_0|data_out[0]}] -to [get_pins {fpga_top|inst_green_bs|bsp_interface_inst|ddr4*_reset_sync|resync_chains[0].synchronizer_nocut|*|clrn}] 100.000
set_min_delay -from [get_keepers {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|tcm_control_out|pio_0|data_out[0]}] -to [get_pins {fpga_top|inst_green_bs|bsp_interface_inst|ddr4*_reset_sync|resync_chains[0].synchronizer_nocut|*|clrn}] -100.000



set_clock_groups -asynchronous -group [get_clocks {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|outclk*}]

# Add clock uncertainty between the 1x and 2x clocks to avoid hold time violations.
# These settings should only be applied when running the fitter.
if {[string equal $::TimeQuestInfo(nameofexecutable) "quartus_default"]} {
  set_clock_uncertainty -add -setup -from [get_clocks {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|outclk0}] -to [get_clocks {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|outclk1}] 0.01
  set_clock_uncertainty -add -hold  -from [get_clocks {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|outclk0}] -to [get_clocks {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|outclk1}] 0.01
  set_clock_uncertainty -add -setup -from [get_clocks {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|outclk1}] -to [get_clocks {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|outclk0}] 0.01
  set_clock_uncertainty -add -hold  -from [get_clocks {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|outclk1}] -to [get_clocks {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|outclk0}] 0.01
}

