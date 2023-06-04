create_generated_clock -name tck_core -source [get_nets {*core_pll|xcvr_fpll_a10_0|outclk0}] -divide_by 6 [get_nets {inst_fiu_top|inst_ccip_fabric_top|inst_fme_top|inst_PR_cntrl|inst_sec_block|i_sec_ijtagif|i_ijt_tckm|xtck}]

set_false_path -to [get_registers *inst_PR_cntrl|tdocore_T1*]
