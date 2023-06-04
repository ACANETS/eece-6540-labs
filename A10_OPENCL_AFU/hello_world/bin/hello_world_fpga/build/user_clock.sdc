
#3.0ns for 333mhz
#2.86ns for 350mhz
#2.5ns for 400mhz
#2.3ns 434mhz
#2.222ns 450mhz
#1.5ns for 666mhz
#1.43ns for 700mhz
#1.25ns 800mhz

if {! [string equal $::TimeQuestInfo(nameofexecutable) "quartus_sta"]} {
  # tighten Kernel constraints during flat compile

  #kernel clk 1x / uClk_usrDiv2
  create_clock -name {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|outclk0} -period 3.0 [get_pins {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|fpll_inst|outclk[0]}] 

  #kernel clk 2x / uClk_usr
  create_clock -name {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|outclk1} -period 1.5 [get_pins {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|fpll_inst|outclk[1]}] 
} else {
  #kernel clk 1x / uClk_usrDiv2
  create_clock -name {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|outclk0} -period 3.0 [get_pins {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|fpll_inst|outclk[0]}] 
  
  #kernel clk 2x / uClk_usr_name
  create_clock -name {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|outclk1} -period 1.5 [get_pins {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|fpll_inst|outclk[1]}]
}
