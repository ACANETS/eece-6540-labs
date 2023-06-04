# Generated clock constraint
create_generated_clock -name {pmbus_clk} -source [get_nets {*kti_phy|inst_kti_phy|altera_upiphy_intccru_inst|core_pll|*|outclk2}] -divide_by 8 [get_nets {*inst_ptmgr_skx_top*ffs_ck100_vl3_ck100_cnt[2]}]
set_clock_groups -asynchronous  -group [get_clocks {pmbus_clk}]
#set_clock_groups -asynchronous  -group [get_clocks {altera_ts_clk}] -group [get_clocks {*qph_reset_pll_fab_s45_inst*outclk[4]}]
