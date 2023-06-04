## Generated SDC file "ccip_fabric.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.0.0 Build 156 04/24/2013 SJ Full Version"

## DATE    "Wed Jan 14 22:33:41 2015"

##
## DEVICE  "5SGXEA7N1F45C2"
##


#**************************************************************
# Time Information
#**************************************************************




#**************************************************************
# Create Clock
#**************************************************************

#create_clock -name {Clk_32UI} -period 4.000 -waveform { 0.000 2.000 } [get_ports {Clk_32UI}]
#create_clock -name {Clk_16UI} -period 2.000 -waveform { 0.000 1.000 } [get_ports {Clk_16UI}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************
# pcie async fifo reset

set_false_path -from [get_registers {*inst_ccip_fabric_top*ccie_t_cdc*cdn2x_SoftReset_T1*} ] -to [get_cells -compatibility_mode {*inst_ccip_fabric_top*ccie_t_cdc*inst_async_CfgTx_fifo*}]
set_false_path -from [get_registers {*inst_ccip_fabric_top*ccie_t_cdc*cdn2x_SoftReset_T1*} ] -to [get_cells -compatibility_mode {*inst_ccip_fabric_top*ccie_t_cdc*inst_async_C0Tx_fifo*}]
set_false_path -from [get_registers {*inst_ccip_fabric_top*ccie_t_cdc*cdn2x_SoftReset_T1*} ] -to [get_cells -compatibility_mode {*inst_ccip_fabric_top*ccie_t_cdc*inst_async_C1Tx_fifo*}]
set_false_path -from [get_registers {*inst_ccip_fabric_top*ccie_t_cdc*cdn2x_SoftReset_T1*} ] -to [get_cells -compatibility_mode {*inst_ccip_fabric_top*ccie_t_cdc*inst_async_C0Rx_fifo*}]
set_false_path -from [get_registers {*inst_ccip_fabric_top*ccie_t_cdc*cdn2x_SoftReset_T1*} ] -to [get_cells -compatibility_mode {*inst_ccip_fabric_top*ccie_t_cdc*inst_async_C1Rx_fifo*}]

# pcie cdc ap enable clock crossing
set_false_path -to [get_registers {*inst_ccip_fabric_top*ccie_t_cdc*cup_ap_tx_en_cdc[0]} ]

set_false_path -to [get_registers {*inst_ccip_fabric_top*ccie_t_cdc*cup_SoftReset_n_cdc*} ]
set_false_path -to [get_registers {*inst_ccip_fabric_top*ccie_t_cdc*cup_ap_state_cdc*} ]

set_false_path -to [get_registers {*ccip_fabric_top|cavl0_SystemReset_n_1}]

# error synchronizer
set_false_path -to [get_registers {*ccip_fabric_top*ccie_t_cdc*error_grpA_v_cdc*}]
set_false_path -to [get_registers {*ccip_fabric_top*ccie_t_cdc*error_grpA_ack_cdc*}]
set_false_path -from [get_registers {*ccip_fabric_top*ccie_t_cdc*cup_error_grpA*}] -to [get_registers {*ccip_fabric_top*ccie_t_cdc*cdn1x_error_grpA*}]

# initDn synchronizer
set_false_path -to [get_registers {*ccip_fabric_top*inst_pcie0_cdc*cdnrx_initDn_cdc*}]
set_false_path -to [get_registers {*ccip_fabric_top*inst_pcie1_cdc*cdnrx_initDn_cdc*}]


# NA in DCP
## IOMMU vtd_epm synchronizer and PMR address registers
#set_false_path -to [get_registers {*inst_ccip_fabric_top*inst_sec_intf*vtd_epm_sync1*} ]
#set_false_path -from [get_registers {*inst_ccip_fabric_top*inst_sec_intf*vtd_p*base*} ]  -to [get_cells -compatibility_mode {*inst_ccip_fabric_top*inst_c*_devtlb*lower_range_base*}]
#set_false_path -from [get_registers {*inst_ccip_fabric_top*inst_sec_intf*vtd_p*base*} ]  -to [get_cells -compatibility_mode {*inst_ccip_fabric_top*inst_c*_devtlb*higher_range_base*}]
#set_false_path -from [get_registers {*inst_ccip_fabric_top*inst_sec_intf*vtd_p*limit*} ] -to [get_cells -compatibility_mode {*inst_ccip_fabric_top*inst_c*_devtlb*lower_range_limit*}]
#set_false_path -from [get_registers {*inst_ccip_fabric_top*inst_sec_intf*vtd_p*limit*} ] -to [get_cells -compatibility_mode {*inst_ccip_fabric_top*inst_c*_devtlb*higher_range_limit*}]

# flr_completed_vf/flr_completed_pf synchrnozier to PCIe clock
set_false_path -to [get_registers {*inst_ccip_fabric_top*inst_ccip_front_end*flr_completed_vf_sync1*} ]
set_false_path -to [get_registers {*inst_ccip_fabric_top*inst_ccip_front_end*flr_completed_pf_sync1*} ]

# flr_rcvd_vf_flag and flr_active_pf synchronizer from PCIe clock to Clk32
set_false_path -from [get_registers {*inst_ccip_fabric_top*inst_ccip_front_end*flr_rcvd_vf_flag*} ]         -to [get_registers {*inst_ccip_fabric_top*inst_ccip_front_end*flr_rcvd_vf_flag_sync1*} ]
set_false_path -from [get_registers {*inst_pcie0_ccib_top*altpcie_sriov2_cfg_fn0_regset_inst*flr_active*} ] -to [get_registers {*inst_ccip_fabric_top*inst_ccip_front_end*flr_active_pf_sync1*} ]

# NA for DCP
# Bus/Device numbers from PCIe HIP to IOMMU. Multi-bit signals, but will be stable before used in IOMMU.
# These go into a two-stage synchronizer, but nothing done to sync all bits at once due to above comment.
#set_false_path -to [get_registers {*inst_ccip_fabric_top*inst_iommu_top*u_cci_pri_if_wrapper*bus_num_d*} ]
#set_false_path -to [get_registers {*inst_ccip_fabric_top*inst_iommu_top*u_cci_pri_if_wrapper*dev_num_d*} ]

#**************************************************************
# Set Multicycle Path
#**************************************************************

# RxPorts from PCIe cdc to CVL
#set_multicycle_path -setup -end -through [get_nets {*inst_ccip_fabric_top*inst_pcie0_cdc*} ] -to [get_cells -compatibility_mode {*inst_ccip_fabric_top*c16ui_xy2cvl_RxPort*} ] 2
#set_multicycle_path -hold  -end -through [get_nets {*inst_ccip_fabric_top*inst_pcie0_cdc*} ] -to [get_cells -compatibility_mode {*inst_ccip_fabric_top*c16ui_xy2cvl_RxPort*} ] 1
#set_multicycle_path -setup -end -through [get_nets {*inst_ccip_fabric_top*inst_pcie1_cdc*} ] -to [get_cells -compatibility_mode {*inst_ccip_fabric_top*c16ui_xy2cvl_RxPort*} ] 2
#set_multicycle_path -hold  -end -through [get_nets {*inst_ccip_fabric_top*inst_pcie1_cdc*} ] -to [get_cells -compatibility_mode {*inst_ccip_fabric_top*c16ui_xy2cvl_RxPort*} ] 1

# PCIe CDC to performance monitor
#set_multicycle_path -setup -end -through [get_nets {*inst_ccip_fabric_top|inst_pcie0_cdc|inst_async_C0Rx_fifo*} ] -to [get_cells -compatibility_mode {*inst_ccip_fabric_top|inst_perf_mon_fab*} ] 2
#set_multicycle_path -hold  -end -through [get_nets {*inst_ccip_fabric_top|inst_pcie0_cdc|inst_async_C0Rx_fifo*} ] -to [get_cells -compatibility_mode {*inst_ccip_fabric_top|inst_perf_mon_fab*} ] 1

###########################################
# leeping: commented out MCP paths for now, remove all these once thing is working
# CSR MCP paths
#set_multicycle_path -setup -start -from {*inst_ccip_fabric_top*ccip_front_end*} -to [get_registers {*inst_ccip_fabric_top*ccip_front_end*fe2cr_debug0*} ] 2
#set_multicycle_path -hold  -start -from {*inst_ccip_fabric_top*ccip_front_end*} -to [get_registers {*inst_ccip_fabric_top*ccip_front_end*fe2cr_debug0*} ] 1

#set_multicycle_path -setup -start -from {*inst_ccip_fabric_top*ccip_front_end*} -to [get_registers {*inst_ccip_fabric_top*ccip_front_end*fsm_status*} ] 2
#set_multicycle_path -hold  -start -from {*inst_ccip_fabric_top*ccip_front_end*} -to [get_registers {*inst_ccip_fabric_top*ccip_front_end*fsm_status*} ] 1

#set_multicycle_path -setup -start -from {*inst_ccip_fabric_top*ccip_front_end*} -to [get_registers {*inst_ccip_fabric_top*ccip_front_end*sts_reset_flush_done*} ] 2
#set_multicycle_path -hold  -start -from {*inst_ccip_fabric_top*ccip_front_end*} -to [get_registers {*inst_ccip_fabric_top*ccip_front_end*sts_reset_flush_done*} ] 1

# <Added by : lpchua>
# Following paths are multicycle -2 paths in the ccip_fabric_top 
# The destination registers latch the data on the second 16UI clock within one 32UI launch clock, gated by c16ui_outOf32uiPhase_b/c16ui_outOf32uiPhase_c
#set_multicycle_path -setup -end -from [get_keepers {*inst_ccip_fabric_top|inst_cvl_top|gen_ccip_ports[*].inst_csr_mux|*}]  -to [get_registers {*inst_ccip_fabric_top*c16ui_TxCfg*}] 2
#set_multicycle_path -hold -end -from [get_keepers {*inst_ccip_fabric_top|inst_cvl_top|gen_ccip_ports[*].inst_csr_mux|*}]  -to [get_registers {*inst_ccip_fabric_top*c16ui_TxCfg*}] 1
#set_multicycle_path -setup -end -from [get_keepers {*inst_ccip_fabric_top|inst_cvl_top|gen_ccip_ports[*].inst_port_csr|*}]  -to [get_registers {*inst_ccip_fabric_top*c16ui_TxCfg*}] 2
#set_multicycle_path -hold -end -from [get_keepers {*inst_ccip_fabric_top|inst_cvl_top|gen_ccip_ports[*].inst_port_csr|*}]  -to [get_registers {*inst_ccip_fabric_top*c16ui_TxCfg*}] 1
#set_multicycle_path -setup -end -from [get_keepers {*inst_ccip_fabric_top|inst_cvl_top|gen_ccip_ports[*].inst_remote_green_stp|*}]  -to [get_registers {*inst_ccip_fabric_top*c16ui_TxCfg*}] 2
#set_multicycle_path -hold -end -from [get_keepers {*inst_ccip_fabric_top|inst_cvl_top|gen_ccip_ports[*].inst_remote_green_stp|*}]  -to [get_registers {*inst_ccip_fabric_top*c16ui_TxCfg*}] 1
#set_multicycle_path -setup -end -from [get_keepers {*inst_ccip_fabric_top|inst_fme_top|inst_csr_mux|*}]  -to [get_registers {*inst_ccip_fabric_top*c16ui_TxCfg*}] 2
#set_multicycle_path -hold -end -from [get_keepers {*inst_ccip_fabric_top|inst_fme_top|inst_csr_mux|*}]  -to [get_registers {*inst_ccip_fabric_top*c16ui_TxCfg*}] 1
#set_multicycle_path -setup -end -from [get_keepers {*inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|*}]  -to [get_registers {*inst_ccip_fabric_top*c16ui_TxCfg*}] 2
#set_multicycle_path -hold -end -from [get_keepers {*inst_ccip_fabric_top|inst_fme_top|inst_fme_csr|*}]  -to [get_registers {*inst_ccip_fabric_top*c16ui_TxCfg*}] 1


## Mariano NEED to REVIEW
#set_multicycle_path -setup -start -from [get_registers {*inst_ccip_fabric_top*fme_csr*csr_reg*} ] 2
#set_multicycle_path -hold  -start -from [get_registers {*inst_ccip_fabric_top*fme_csr*csr_reg*} ] 1
#set_multicycle_path -setup -start -from [get_registers {*inst_ccip_fabric_top*port_csr*csr_reg*} ] 2
#set_multicycle_path -hold  -start -from [get_registers {*inst_ccip_fabric_top*port_csr*csr_reg*} ] 1
#
## DO NOT MCP the PCIe0 to CSR access bus
#set_multicycle_path -setup -start -from [get_registers {*inst_ccip_fabric_top*fme_csr*csr_reg*} ]  -to [get_registers {*inst_ccip_fabric_top*c16ui_TxCfgRdValid*}] 1
#set_multicycle_path -hold  -start -from [get_registers {*inst_ccip_fabric_top*fme_csr*csr_reg*} ]  -to [get_registers {*inst_ccip_fabric_top*c16ui_TxCfgRdValid*}] 0
#set_multicycle_path -setup -start -from [get_registers {*inst_ccip_fabric_top*port_csr*csr_reg*} ] -to [get_registers {*inst_ccip_fabric_top*c16ui_TxCfgRdValid*}] 1
#set_multicycle_path -hold  -start -from [get_registers {*inst_ccip_fabric_top*port_csr*csr_reg*} ] -to [get_registers {*inst_ccip_fabric_top*c16ui_TxCfgRdValid*}] 0
#
#
## CSR input signals
## Mariano NEED to REVIEW
#set_multicycle_path -setup -end   -to [get_registers {*inst_ccip_fabric_top*fme_csr*csr_reg*} ] 1
#set_multicycle_path -hold  -end   -to [get_registers {*inst_ccip_fabric_top*fme_csr*csr_reg*} ] 0
#set_multicycle_path -setup -end   -to [get_registers {*inst_ccip_fabric_top*port_csr*csr_reg*} ] 1
#set_multicycle_path -hold  -end   -to [get_registers {*inst_ccip_fabric_top*port_csr*csr_reg*} ] 0

#set_multicycle_path -setup -end -from [get_cells {*inst_ccip_fabric_top*inst_pcie0_cdc*}]  -to [get_registers {*inst_ccip_fabric_top*fme_csr*csr_reg*} ] 1
#set_multicycle_path -hold  -end -from [get_cells {*inst_ccip_fabric_top*inst_pcie0_cdc*}]  -to [get_registers {*inst_ccip_fabric_top*fme_csr*csr_reg*} ] 0
#set_multicycle_path -setup -end -from [get_cells {*inst_ccip_fabric_top*inst_pcie0_cdc*}]  -to [get_registers {*inst_ccip_fabric_top*port_csr*csr_reg*} ] 1
#set_multicycle_path -hold  -end -from [get_cells {*inst_ccip_fabric_top*inst_pcie0_cdc*}]  -to [get_registers {*inst_ccip_fabric_top*port_csr*csr_reg*} ] 0
#set_max_delay -from [get_registers {*cci_std_afu*SoftReset_n*}] 5.0

###########################################

#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

