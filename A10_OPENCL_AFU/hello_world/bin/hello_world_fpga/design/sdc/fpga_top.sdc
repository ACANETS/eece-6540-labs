set_time_format -unit ns -decimal_places 3

create_clock -name SYS_RefClk             -period  10.000 -waveform {0.000  5.000} [get_ports {SYS_RefClk}]
#create_clock -name FAB_RefClk             -period  10.000 -waveform {0.000  5.000} [get_ports {FAB_RefClk}]
create_clock -name HSSI_RefClk            -period  10.000 -waveform {0.000  5.000} [get_ports {HSSI_RefClk}]
create_clock -name ETH_RefClk             -period   3.103 -waveform {0.000  1.600} [get_ports {ETH_RefClk}]
create_clock -name CLKUSR                 -period  10.000 -waveform {0.000  5.000} [get_ports {CLKUSR_inp}]
create_clock -name {altera_reserved_tck}  -period 100.000 -waveform {0.000 50.000} [get_ports {altera_reserved_tck}]
create_clock -name {ps16clk}              -period   1.650 -waveform {0.000  0.825} [get_nets  {*vl_qph_user_clk_clkpsc}]

derive_pll_clocks -create_base_clocks  
derive_clock_uncertainty

######################################################################################################################################
#   Temp set asynchronous between clocks -- will be removed once IP owners fix the paths or convert them to false paths in IP sdc    #
######################################################################################################################################
#  set_clock_groups -asynchronous -group [get_clocks {HSSI_RefClk}]
#  set_clock_groups -asynchronous -group [get_clocks {ETH_RefClk}]
  set_clock_groups -asynchronous -group [get_clocks {*altera_reserved*}]
  set_clock_groups -asynchronous -group [get_clocks {*|altera_upiphy_intccru_inst|*pll*|*outclk*0}] \
                                 -group [get_clocks {*upiphy*tx_clkout*}]                                
  set_clock_groups -asynchronous -group [get_clocks {*|altera_upiphy_intccru_inst|*pll*|*outclk*0}] \
                                 -group [get_clocks {*upiphy*tx_bonding_clocks*}]                                
  set_clock_groups -asynchronous -group [get_clocks {*|altera_upiphy_intccru_inst|*pll*|*outclk*0}] \
                                 -group [get_clocks {*upiphy*rx_clkout*}]                                                               
  set_clock_groups -asynchronous -group [get_clocks {*|altera_upiphy_intccru_inst|*pll*|*outclk*0}] \
                                 -group [get_clocks {*upiphy*rx_pma_clk*}]                                                              
                                 
  set_clock_groups -asynchronous -group {hssi_pll_r_outclk0} \
                                 -group {hssi_pll_r_outclk1} \
                                 -group {hssi_pll_t_outclk0} \
                                 -group {hssi_pll_t_outclk1} \
                                 -group {inst_fiu_top|kti_top|kti_phy|inst_kti_phy|altera_upiphy_intccru_inst|core_pll|xcvr_fpll_a10_0|outclk2}
  set_clock_groups -asynchronous -group {inst_fiu_top|inst_hssi_eth|ntv0|serdes0|g_xcvr_native_insts[*]|rx_pma_clk}

######################################################################################################################################
#     Temp sdc to mask top violations -- will be removed once IP owners fix them or false path in IP sdc                             #
######################################################################################################################################

if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
 
#  set_false_path -from     *inst_hssi_rp0                -to  *inst_hssi_rp0 
#  set_false_path -from     *inst_hssi_rp1                -to  *inst_hssi_rp1 
} else {
set_clock_uncertainty -add -setup 0.1 -from [get_clocks {*|altera_upiphy_intccru_inst|*pll*|*outclk*0}] -to [get_clocks {*|altera_upiphy_intccru_inst|*pll*|*outclk*1}]
set_clock_uncertainty -add -setup 0.1 -from [get_clocks {*|altera_upiphy_intccru_inst|*pll*|*outclk*1}] -to [get_clocks {*|altera_upiphy_intccru_inst|*pll*|*outclk*0}]
set_max_delay -from [get_registers {*ram_for_hpa*}] -to [get_registers {*higher_range_limit*}] 2.3
set_max_delay -from [get_registers {*ram_for_gpa*}] -to [get_registers {*higher_range_limit*}] 2.3
set_max_delay -from [get_registers {*ram_for_hpa*}] -to [get_registers {*higher_range_base*}]  2.3
set_max_delay -from [get_registers {*fill_and_read_index_match*}] -to [get_registers {*higher_range_base*}]  2.3
}                               
