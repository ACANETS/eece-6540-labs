# (C) 2001-2017 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


# derive_pll_clock is used to calculate all clock derived from PCIe refclk
#  the derive_pll_clocks and derive clock_uncertainty should only
# be applied once across all of the SDC files used in a project
# derive_pll_clocks -create_base_clocks
# derive_clock_uncertainty

set testin_size_collection_pcie 0
set testin_collection_pcie [get_registers -nowarn {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|altpcie_test_in_static_signal_to_be_false_path[*]}]
set testin_size_collection_pcie [get_collection_size $testin_collection_pcie]

if {$testin_size_collection_pcie > 0} {
  set_false_path -from [get_registers {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|altpcie_test_in_static_signal_to_be_false_path[*]}]
  set_false_path -to [get_registers {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|altpcie_test_in_static_signal_to_be_false_path[*]}]
}

set_max_skew -from [get_registers {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys~pld_clk.reg}] -to [get_registers {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|dbg_rx_data_reg[*]   *|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|dbg_rx_datak_reg[*] }] 6.500
set_max_skew -from [get_registers {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys~pld_clk.reg}] -to [get_registers {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|dbg_rx_data_reg_1[*]  *|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|dbg_rx_datak_reg_1[*] }] 6.500

set_max_delay -from [get_registers {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys~pld_clk.reg}] -to [get_registers {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|dbg_rx_data_reg[*]  *|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|dbg_rx_data_reg_1[*] *|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|dbg_rx_datak_reg[*] *|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|dbg_rx_datak_reg_1[*] }] 10.000
set_false_path -from {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys~pld_clk.reg} -to {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|altpcie_sc_bitsync_node:rx_polinv_dbg.dbg_rx_valid_altpcie_sc_bitsync_1|altpcie_sc_bitsync:altpcie_sc_bitsync|altpcie_sc_bitsync_meta_dff[0]}
set_false_path -from {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys~pld_clk.reg} -to {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|altpcie_sc_bitsync_node:rx_polinv_dbg.dbg_rx_valid_altpcie_sc_bitsync|altpcie_sc_bitsync:altpcie_sc_bitsync|altpcie_sc_bitsync_meta_dff[0]}

set_multicycle_path -setup -through [get_pins -compatibility_mode -nocase {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys|tl_cfg_add[*]}] 2 
set_multicycle_path -hold  -through [get_pins -compatibility_mode -nocase {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys|tl_cfg_add[*]}] 2 
set_multicycle_path -setup -through [get_pins -compatibility_mode -nocase {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys|tl_cfg_ctl[*]}] 2 
set_multicycle_path -hold  -through [get_pins -compatibility_mode -nocase {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys|tl_cfg_ctl[*]}] 2

