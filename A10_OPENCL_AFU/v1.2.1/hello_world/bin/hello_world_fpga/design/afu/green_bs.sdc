set_max_skew -from [get_keepers {fpga_top|inst_blue_ccip_interface_reg|pck_cp2af_softReset_T0_q}] -to [get_pins {fpga_top|inst_green_bs|ddr4*_reset_sync|resync_chains[0].synchronizer_nocut|*|clrn}] -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.800 
set_max_delay -from [get_keepers {fpga_top|inst_blue_ccip_interface_reg|pck_cp2af_softReset_T0_q}] -to [get_pins {fpga_top|inst_green_bs|ddr4*_reset_sync|resync_chains[0].synchronizer_nocut|*|clrn}] 100.000
set_min_delay -from [get_keepers {fpga_top|inst_blue_ccip_interface_reg|pck_cp2af_softReset_T0_q}] -to [get_pins {fpga_top|inst_green_bs|ddr4*_reset_sync|resync_chains[0].synchronizer_nocut|*|clrn}] -100.000

# Reset is comes from the TCM during a BIP compile
set_max_skew -from [get_keepers {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|tcm_control_out|pio_0|data_out[0]}] -to [get_pins {fpga_top|inst_green_bs|ddr4*_reset_sync|resync_chains[0].synchronizer_nocut|*|clrn}] -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.800 
set_max_delay -from [get_keepers {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|tcm_control_out|pio_0|data_out[0]}] -to [get_pins {fpga_top|inst_green_bs|ddr4*_reset_sync|resync_chains[0].synchronizer_nocut|*|clrn}] 100.000
set_min_delay -from [get_keepers {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|tcm_control_out|pio_0|data_out[0]}] -to [get_pins {fpga_top|inst_green_bs|ddr4*_reset_sync|resync_chains[0].synchronizer_nocut|*|clrn}] -100.000


