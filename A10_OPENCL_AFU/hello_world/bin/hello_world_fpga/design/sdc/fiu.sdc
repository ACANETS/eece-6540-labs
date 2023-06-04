# Commented out these constraints because FME_ProcHot_N and FME_Mbp_N are set to '1' in dcp_top
# Add false path on synchronizers
#set_false_path -from [get_ports {FME_ProcHot_N}] -to [get_registers {inst_fiu_top|FME_ProcHot_sync_N*}]
#set_false_path -from [get_ports {FME_Mbp_N}] -to [get_registers {inst_fiu_top|FME_Mbp_sync_N*}]

# Contraints for the clock mux that selects between fpll outclk[0] and outclk[1]
create_generated_clock -name vl_qph_user_clk_clkpsc_clk0 -source [get_pins {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|fpll_inst|outclk[0]}] [get_pins {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_freq_u0|vl_qph_user_clk_clkpsc|combout}]
create_generated_clock -add -name vl_qph_user_clk_clkpsc_clk1 -source [get_pins {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_fpll_u0|xcvr_fpll_a10_0|fpll_inst|outclk[1]}] [get_pins {fpga_top|inst_fiu_top|inst_ccip_fabric_top|inst_cvl_top|inst_user_clk|qph_user_clk_freq_u0|vl_qph_user_clk_clkpsc|combout}]

set_clock_groups -asynchronous\
  -group [get_clocks {vl_qph_user_clk_clkpsc_clk0}]\
  -group [get_clocks {vl_qph_user_clk_clkpsc_clk1}]

