# Note - Consider set_max_delay constraints
set_false_path -to [get_registers {*inst_fme_top*c100_sync_reset_full_cdc_n*0*} ]
# For input to a 2-FFs synchronizer chain within USER_CLK module
set_false_path -from [get_registers {*|inst_user_clk|*|ffs_ckpsc_vl4_prescaler[*]}] -to [get_registers {*|inst_user_clk|*|ffs_ck100_vl_smpclk_meta}]
# For PCIe HIP status signal to FAB_STATUS reg
set_max_delay -from    *cci*pcie_a10_hip_0*          -to  *fme*csr_reg*   5.0
# For PCIe HIP error signals
set_false_path -from [get_registers {*|inst_pcie*_ccib_top|avl_cci_bridge|b2c_rx_err*}] -to [get_registers {*|inst_fme_top|b2c_rx_err_*}]


