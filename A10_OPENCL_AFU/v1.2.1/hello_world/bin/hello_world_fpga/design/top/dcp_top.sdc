set_time_format -unit ns -decimal_places 3

# Default clocks for HSSI PLLs
create_clock -name {hssi_pll_r_0_outclk0} -period 3.800 -waveform { 0.000 1.900 } [get_nets {*|inst_hssi_ctrl|pll_r_0|xcvr_fpll_a10_0|outclk0}]
create_clock -name {hssi_pll_r_0_outclk1} -period 3.800 -waveform { 0.000 1.900 } [get_nets {*|inst_hssi_ctrl|pll_r_0|xcvr_fpll_a10_0|outclk1}]
create_clock -name {hssi_pll_t_outclk0}   -period 3.800 -waveform { 0.000 1.900 } [get_nets {*|inst_hssi_ctrl|pll_t|xcvr_fpll_a10_0|outclk0}]
create_clock -name {hssi_pll_t_outclk1}   -period 3.800 -waveform { 0.000 1.900 } [get_nets {*|inst_hssi_ctrl|pll_t|xcvr_fpll_a10_0|outclk1}]

set inst_list [get_entity_instances -nowarn "green_hssi_e10"]
if {$inst_list > 0} {
create_clock -name {hssi_pll_r_0_outclk0} -period 6.400 -waveform { 0.000 3.200 } [get_nets {*|inst_hssi_ctrl|pll_r_0|xcvr_fpll_a10_0|outclk0}]
create_clock -name {hssi_pll_r_0_outclk1} -period 3.200 -waveform { 0.000 1.600 } [get_nets {*|inst_hssi_ctrl|pll_r_0|xcvr_fpll_a10_0|outclk1}]
create_clock -name {hssi_pll_t_outclk0}   -period 6.400 -waveform { 0.000 3.200 } [get_nets {*|inst_hssi_ctrl|pll_t|xcvr_fpll_a10_0|outclk0}]
create_clock -name {hssi_pll_t_outclk1}   -period 3.200 -waveform { 0.000 1.600 } [get_nets {*|inst_hssi_ctrl|pll_t|xcvr_fpll_a10_0|outclk1}]
}

set inst_list [get_entity_instances -nowarn "green_hssi_e40"]
if {$inst_list > 0} {
create_clock -name {hssi_pll_r_0_outclk0} -period 3.200 -waveform { 0.000 1.600 } [get_nets {*|inst_hssi_ctrl|pll_r_0|xcvr_fpll_a10_0|outclk0}]
create_clock -name {hssi_pll_t_outclk0}   -period 3.200 -waveform { 0.000 1.600 } [get_nets {*|inst_hssi_ctrl|pll_t|xcvr_fpll_a10_0|outclk0}]
}

create_clock -name SYS_RefClk             -period  10.000 -waveform {0.000  5.000} [get_ports {SYS_RefClk}]
create_clock -name QSFP1_REFCLK_OSC_P     -period   3.103 -waveform {0.000  1.5515} [get_ports {QSFP1_REFCLK_OSC_P}]
create_clock -name {altera_reserved_tck}  -period 100.000 -waveform {0.000 50.000} [get_ports {altera_reserved_tck}]
set_clock_groups -asynchronous -group {altera_reserved_tck}
# SPI Serial Clock Definition: 4MHz.  Will also apply phase noise provided by Bittware to provide better accuracy for RC 1.2.1 constraints in section below.---------------------------------------
create_clock -name {fspi_sclk} -period 250.000 -waveform {0 125} [get_ports {fspi_sclk}]
create_generated_clock -name filtered_sclk_negedge -source [get_ports {fspi_sclk}] -divide_by 1 -multiply_by 1 -duty_cycle 2 -phase 0 -offset 0 [get_pins {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|filtered_sclk_negedge|q}]
set_input_delay  -clock {fspi_sclk} -min -5 [get_ports {fspi_cs_l}]
set_input_delay  -clock {fspi_sclk} -max  5 [get_ports {fspi_cs_l}]
set_input_delay  -clock {fspi_sclk} -min -5 [get_ports {fspi_mosi}]
set_input_delay  -clock {fspi_sclk} -max  5 [get_ports {fspi_mosi}]
set_output_delay -clock {fspi_sclk} -min -5 [get_ports {fspi_miso}]
set_output_delay -clock {fspi_sclk} -max  5 [get_ports {fspi_miso}]

set_max_skew -from_clock { u0|dcp_iopll|dcp_iopll|clk1x } -to_clock { filtered_sclk_negedge }  20
set_max_delay -from [get_keepers {*filtered_mosi*}] 30

# SPI Serial Clock END.----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create_clock -name {flash_oe_clk} -period 40.000 -waveform {0 20} [get_registers {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|generic_quad_spi_controller2_0|generic_quad_spi_controller2_0|asmi2_inst_qspi_ctrl|csr_controller|csr_control_data_reg[0]}]

derive_pll_clocks -create_base_clocks  
derive_clock_uncertainty

set_clock_groups -asynchronous -group [get_clocks {hssi_pll_r_0_outclk0 hssi_pll_r_0_outclk1}] \
                               -group [get_clocks {hssi_pll_t_outclk0 hssi_pll_t_outclk1}] \
                               -group [get_clocks {SYS_RefClk}]
set_clock_groups -asynchronous -group [get_clocks {fpga_top|inst_fiu_top|inst_hssi_ctrl|ntv0|xcvr_native_a10_0|g_xcvr_native_insts[*]*|rx_pma_clk}]
# Timing Constraints Added for RC 1.2.1 Closure -------------------------------------------------------------------------------------
# Flash OE and main clock constraints -----------------------------------------------------------------------------------------------
#set_multicycle_path -setup -end 0 -rise_from [get_clocks flash_oe_clk] -rise_to [get_clocks u0|dcp_iopll|dcp_iopll|clk25]
#set_multicycle_path -setup -end 0 -fall_from [get_clocks flash_oe_clk] -fall_to [get_clocks u0|dcp_iopll|dcp_iopll|clk25]
# PR 100MHz clock paths and enables -------------------------------------------------------------------------------------------------
#set_multicycle_path -from [get_clocks {u0|dcp_iopll|dcp_iopll|clk100}] -to [get_clocks {pr_clk_enable_dclk_reg2_user_clk}] -hold -end 1
#set_multicycle_path -from [get_clocks {u0|dcp_iopll|dcp_iopll|clk100}] -to [get_clocks {pr_clk_enable_dclk_reg2_user_clk}] -setup -end 0
#set_false_path -from [get_clocks {u0|dcp_iopll|dcp_iopll|clk100}] -through [get_pins {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[*]|q}] -to [get_clocks {pr_clk_enable_dclk_reg2_user_clk}]
#set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[23]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
#set_multicycle_path -setup -end 0 -fall_from [get_clocks u0|dcp_iopll|dcp_iopll|clk100] -rise_to [get_clocks pr_clk_enable_dclk_reg2_user_clk]
# Individual PR IP path cuts to match up with QSF register placements for "pr_data_reg2[31:0]" PLEASE DONT CONDENSE. --------------------------------------------------------------------------------
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[23]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[31]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[0]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[7]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[30]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[16]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[14]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[18]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[15]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[12]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[22]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[29]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[10]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[2]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[4]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[5]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[24]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[6]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[21]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[19]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[8]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[3]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[11]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[17]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[13]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[28]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[26]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[25]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[9]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[20]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[1]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
set_false_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|pr_data_reg2[27]} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|inst_tcm|alt_pr_0|alt_pr_0|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg}
#set_multicycle_path -setup -end 0 -rise_from [get_clocks u0|dcp_iopll|dcp_iopll|clk100] -fall_to [get_clocks pr_clk_enable_dclk_reg2_user_clk]
# Timing for Flash OE signal and 25MHz Flash clock must be separated ----------------------------------------------------------------
set_clock_groups -asynchronous -group [get_clocks {flash_oe_clk}] \
                               -group [get_clocks {u0|dcp_iopll|dcp_iopll|clk25}]
# SPI Clock Constraints -------------------------------------------------------------------------------------------------------------
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MISOctl|rdshiftreg*} -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MISOctl|rdshiftreg*} -hold -start 1
# Multicycle constraints set for specific Recovery Time paths in the SPI PHY. -------------------------------------------------------
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MISOctl|loadstsinkdata}                -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MISOctl|sync_miso_ack|dreg[0]}         -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MISOctl|sclkpedgecounter[0]}           -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MISOctl|sclkpedgecounter[2]}           -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MISOctl|sclkpedgecounter[1]}           -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|sclkpedgecounter[2]}           -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|sclkpedgecounter[0]}           -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|sclkpedgecounter[1]}           -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|sync_mosi_ack|dreg[0]}         -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|wrshiftreg[1]}                 -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|wrshiftreg[6]}                 -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|wrshiftreg[4]}                 -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|wrshiftreg[2]}                 -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|sclkpedgecounter[0]~DUPLICATE} -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|wrshiftreg[3]}                 -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|wrshiftreg[0]}                 -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|wrshiftreg[5]}                 -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|sendsetvalid}                  -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|stsourcedata[3]}               -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|stsourcedata[2]}               -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|stsourcedata[5]}               -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|stsourcedata[0]}               -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|stsourcedata[4]}               -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|stsourcedata[1]}               -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|stsourcedata[6]}               -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|stsourcedata[7]}               -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MISOctl|loadstsinkdata}                -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MISOctl|sync_miso_ack|dreg[0]}         -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MISOctl|sclkpedgecounter[0]}           -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MISOctl|sclkpedgecounter[2]}           -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MISOctl|sclkpedgecounter[1]}           -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|sclkpedgecounter[2]}           -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|sclkpedgecounter[0]}           -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|sclkpedgecounter[1]}           -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|sync_mosi_ack|dreg[0]}         -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|wrshiftreg[1]}                 -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|wrshiftreg[6]}                 -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|wrshiftreg[4]}                 -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|wrshiftreg[2]}                 -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|sclkpedgecounter[0]~DUPLICATE} -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|wrshiftreg[3]}                 -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|wrshiftreg[0]}                 -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|wrshiftreg[5]}                 -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|sendsetvalid}                  -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|stsourcedata[3]}               -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|stsourcedata[2]}               -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|stsourcedata[5]}               -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|stsourcedata[0]}               -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|stsourcedata[4]}               -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|stsourcedata[1]}               -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|stsourcedata[6]}               -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|stsourcedata[7]}               -hold  -start 1
# Multicycle constraints for "data_out" path to general logic in hte SPI PHY block---------------------------------------------------
set_multicycle_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|SPISlaveToAvalonMasterBridge_reset_clk_domain_synch|data_out} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MISOctl|*} -setup -start 2
set_multicycle_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|SPISlaveToAvalonMasterBridge_reset_clk_domain_synch|data_out} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MISOctl|*} -hold -start 1
set_multicycle_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|SPISlaveToAvalonMasterBridge_reset_clk_domain_synch|data_out} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|*} -setup -start 2
set_multicycle_path -from {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|SPISlaveToAvalonMasterBridge_reset_clk_domain_synch|data_out} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MOSIctl|*} -hold -start 1
#                          fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|SPISlaveToAvalonMasterBridge_reset_clk_domain_synch|data_out       fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MISOctl|loadstsinkdata
set_max_delay -from {fspi_cs_l} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MISOctl|*} 30
set_min_delay -from {fspi_cs_l} -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|bmc|spi_bridge|spi_slave_to_avalon_mm_master_bridge_1|the_spislave_inst_for_spichain|the_SPIPhy|SPIPhy_MISOctl|*} -30
set_max_delay -from {fspi_cs_l} -to {fspi_miso} 30
set_min_delay -from {fspi_cs_l} -to {fspi_miso} -30

set_multicycle_path -from [get_keepers {*SPISlaveToAvalonMasterBridge_reset_clk_domain_synch|data_out}] -to [get_keepers {*SPIPhy_MOSIctl|stsourcedata*}] -setup -start 3
set_multicycle_path -from [get_keepers {*SPISlaveToAvalonMasterBridge_reset_clk_domain_synch|data_out}] -to [get_keepers {*SPIPhy_MOSIctl|stsourcedata*}] -hold -start 1
set_multicycle_path -from [get_keepers {*sync_spi_reset|dreg*}] -to [get_keepers {*SPIPhy_MOSIctl|sclkpedgecounter*}] -setup -start 3
set_multicycle_path -from [get_keepers {*sync_spi_reset|dreg*}] -to [get_keepers {*SPIPhy_MOSIctl|sclkpedgecounter*}] -hold -start 1
set_multicycle_path -from [get_keepers {*sync_spi_reset|dreg*}] -to [get_keepers {*SPIPhy_MOSIctl|wrshiftreg*}] -setup -start 3
set_multicycle_path -from [get_keepers {*sync_spi_reset|dreg*}] -to [get_keepers {*SPIPhy_MOSIctl|wrshiftreg*}] -hold -start 1
set_multicycle_path -from [get_keepers {*sync_spi_reset|dreg*}] -to [get_keepers {*SPIPhy_MOSIctl|sendsetvalid}] -setup -start 3
set_multicycle_path -from [get_keepers {*sync_spi_reset|dreg*}] -to [get_keepers {*SPIPhy_MOSIctl|sendsetvalid}] -hold -start 1

# false path from spi reset to sync reg (reset is async wrt spi clk)
set_false_path -from [get_keepers {fspi_cs_l}] -to [get_keepers {*sync_spi_reset*}]

# PCIe clock Domain Constraints -----------------------------------------------------------------------------------------------------
# Open-ended multi-cycle constraints to resolve Recover paths on Reset to "dffe6a[0]" and "dffe7a[0]".
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_msix_top|msix_brid|msix_dcfifo|fifo_0|dcfifo_component|auto_generated|rdaclr|dffe6a[0]} -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_msix_top|msix_brid|msix_dcfifo|fifo_0|dcfifo_component|auto_generated|rdaclr|dffe6a[0]} -hold  -start 1
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_msix_top|msix_brid|msix_dcfifo|fifo_0|dcfifo_component|auto_generated|rdaclr|dffe7a[0]} -setup -start 2
set_multicycle_path -to {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_msix_top|msix_brid|msix_dcfifo|fifo_0|dcfifo_component|auto_generated|rdaclr|dffe7a[0]} -hold  -start 1

# END of RC 1.2.1 Constraints -------------------------------------------------------------------------------------------------------

# Cutting path from temp sense logic to FME sampling logic
set_false_path -from {altera_ts_clk} -to {*dcp_iopll|clk100}
set_false_path -from [get_registers {fpga_top|inst_fiu_top|*|PR_IP|*|freeze_reg}] -to *
set_false_path -from [get_registers {SYS_RST_N}] -to *
set_false_path -from {DDR4_RST_N} -to *
set_false_path -from {HSSI_RST_N} -to *
set_false_path -from [get_registers {fpga_top|inst_fiu_top|*|PR_IP|*|freeze_reg}] -to *

# Cut paths from FME Clock domain to 25 MHz SPIFlash domain
set_false_path -from [get_registers {*|inst_fme_csr|go_bit_r2}] -to [get_clocks {*|dcp_iopll|clk25}]
set_false_path -from [get_registers {*|inst_fme_csr|go_bit_r3}] -to [get_clocks {*|dcp_iopll|clk25}]
set_false_path -from [get_registers {*|inst_fme_csr|csr_reg[14][1][*]}] -to [get_clocks {*|dcp_iopll|clk25}]
set_false_path -from [get_registers {*|inst_hssi_ctrl|*meta*}] -to *
set_false_path -to [get_registers {*|inst_hssi_ctrl|*meta*}] -from *

set_false_path -from [get_registers {fpga_top|inst_green_bs|inst_ccip_std_afu|ENET|rx_rst}] -to *
set_false_path -from [get_registers {fpga_top|inst_green_bs|inst_ccip_std_afu|ENET|tx_rst}] -to *
set_false_path -from [get_registers {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_PR_cntrl|pr2fme_freeze_32UI[0]}] -to *
set_false_path -from [get_ports SYS_RST_N] -to *
set_false_path -from [get_registers {*|inst_hssi_ctrl|system_status_r[*]}] -to [get_registers {*|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|csr_reg[6][2][*]}]
set_false_path -to [get_registers {*|inst_hssi_ctrl|system_ctrl_r[*]}] -from [get_registers {*|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|csr_reg[6][1][*]}]
set_false_path -from [get_registers {*|inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_PR_cntrl|pr2fme_freeze_32UI[0]}]	-to [get_registers {*|inst_fiu_top|inst_hssi_ctrl|aux_rdata[1]}]
set_false_path -through [get_nets {*|hssi.f2a_tx_cal_busy}]
set_false_path -through [get_nets {*|hssi.f2a_tx_cal_locked}]
set_false_path -through [get_nets {*|hssi.f2a_tx_locked}]
set_false_path -through [get_nets {*|hssi.f2a_tx_pll_locked}]
set_false_path -through [get_nets {*|hssi.f2a_rx_cal_busy}]


# Cut paths for unneeded jtag connection ID ROM
set_false_path -from {*|alt_sld_fab_0|sldfabric|\jtag_hub_gen:real_sld_jtag_hub|mix_writedata*} -to {*connection_id_rom*}
set_false_path -from {*|inst_tcm|jtag_uart_0|jtag_uart_0|tcm_jtag_uart_0_altera_avalon_jtag_uart_171_z6yx74y_alt_jtag_atlantic|jupdate~2} -to {*|inst_tcm|jtag_uart_0|jtag_uart_0|tcm_jtag_uart_0_altera_avalon_jtag_uart_171_z6yx74y_alt_jtag_atlantic|jupdate1}


# Async "slow" GPIO signals
set_false_path -from {MACID_SDA} -to *
set_false_path -to {MACID_SDA} -from *
set_false_path -from {QSFP1_SDA} -to *
set_false_path -to {QSFP1_SDA} -from *
set_false_path -from {QSFP1_PRS_L} -to *
set_false_path -from {QSFP1_INT_L} -to *
set_false_path -to {LED_L_0} -from *
set_false_path -to {LED_L_1} -from *
set_false_path -to {LED_L_2} -from *
set_false_path -to {LED_L_3} -from *
set_false_path -to {MACID_SCL} -from *
set_false_path -from {MACID_SCL} -to *
set_false_path -to {MACID_WP} -from *
set_false_path -to {QSFP1_SCL} -from *
set_false_path -from {QSFP1_SCL} -to *
set_false_path -to {QSFP1_LP} -from *
set_false_path -to {QSFP1_RST_L} -from *




	
