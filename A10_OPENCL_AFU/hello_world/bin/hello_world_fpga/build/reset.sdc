# Make the kernel reset multicycle
set_multicycle_path -from * -setup 4 -to {fpga_top|inst_green_bs|bsp_interface_inst|ccip_std_afu|bsp_logic_inst|board_inst|ccip_avmm_bridge_inst|rst_controller_003|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*}
set_multicycle_path -from * -hold 3 -to {fpga_top|inst_green_bs|bsp_interface_inst|ccip_std_afu|bsp_logic_inst|board_inst|ccip_avmm_bridge_inst|rst_controller_003|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*}

set_multicycle_path -from * -setup 4 -to {fpga_top|inst_green_bs|bsp_interface_inst|ccip_std_afu|bsp_logic_inst|board_inst|rst_controller_001|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*}
set_multicycle_path -from * -hold 3 -to {fpga_top|inst_green_bs|bsp_interface_inst|ccip_std_afu|bsp_logic_inst|board_inst|rst_controller_001|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*}

set_multicycle_path -to * -setup 4 -from {fpga_top|inst_green_bs|bsp_interface_inst|ccip_std_afu|bsp_logic_inst|board_inst|kernel_interface|kernel_interface|reset_controller_sw|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out}
set_multicycle_path -to * -hold 3 -from {fpga_top|inst_green_bs|bsp_interface_inst|ccip_std_afu|bsp_logic_inst|board_inst|kernel_interface|kernel_interface|reset_controller_sw|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out}

# Cut path to twoXclock_consumer (this instance is only there to keep 
# kernel interface consistent and prevents kernel_clk2x to be swept away by synthesis)

#this takes out the registers used to measure frequency from the timing report
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_freq_u0|*} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_freq_u0|*}
set_false_path -from * -to {*inst_green_bs|bsp_interface_inst|uClk_usr_q1}
set_false_path -from * -to {*inst_green_bs|bsp_interface_inst|uClk_usr_q2}

set_false_path -from * -to {fpga_top|inst_green_bs|freeze_wrapper_inst|*|kernel|theacl_clock2x_dummy_consumer|twoXclock_consumer_NO_SHIFT_REG}
