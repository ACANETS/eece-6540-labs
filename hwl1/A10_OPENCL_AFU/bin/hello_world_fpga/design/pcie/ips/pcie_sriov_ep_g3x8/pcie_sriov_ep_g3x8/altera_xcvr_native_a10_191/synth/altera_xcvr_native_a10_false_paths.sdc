# (C) 2001-2019 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


# For more information, please refer to the Transceiver User Guide.

# Non-bonded Native PHY configurations
#
# False paths can be set on tx_digitalreset because each channel is
# independent of every other channel in the same instance. Use the false
# path exceptions to remove the tx_digialreset dependency. The following
# three constraints can be enabled and must be modified to include the 
# name of the native phy instance to avoid accidentally constraining
# tx_digitalresets for unrelated Native PHY instances.
#
# set_false_path -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_pmaif_tx_pld_rst_n]
# set_false_path -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_8g_g3_tx_pld_rst_n]
# set_false_path -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_10g_krfec_tx_pld_rst_n]


# Bonded Native PHY configurations
# 
# A false path cannot be set on tx_digitalreset from the reset controller
# since a skew relationship for tx_digitalreset to the transceiver channels
# must be maintained. The -exlude to_clock ensures the that the data delay
# is matched between channels. The following constraints should be modified for 
# hierarchy and skew to match design requirements, where the max_skew should
# satisfy the following: max_skew = tx_clkout_period/2.  The 1ns skew covers
# tx_clkout frequency of 500Mhz, and can be relaxed based upon the design.

# set_max_skew -exclude to_clock \
              -from [get_registers *altera_xcvr_reset_control*tx_digitalreset*r_reset] \
              -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_*_tx_pld_rst_n] 1ns

# To allow the max_skew constraint to be honored while avoiding recover/removal
# violations, the reset paths are further constrained with a min/max delay.  By
# setting a a large min/max delay, the signal is, for all intents and purposes,
# unbounded, and will be treated as if it were a false path.  This gives the
# benefits of  set_false_path exception while allowing the path to be further 
# constrained to meet design requirements. These min/max delay constraints 
# are NOT the same as a false path, and in non-bonded configuration, where 
# applicable, a flase path should be set.

if { [get_collection_size [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_pmaif_tx_pld_rst_n]] > 0 } {
  set_max_delay -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_pmaif_tx_pld_rst_n] 50ns
  set_min_delay -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_pmaif_tx_pld_rst_n] -50ns
}

if { [get_collection_size [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_8g_g3_tx_pld_rst_n]] > 0 } {
  set_max_delay -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_8g_g3_tx_pld_rst_n] 50ns
  set_min_delay -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_8g_g3_tx_pld_rst_n] -50ns
}

if { [get_collection_size [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_10g_krfec_tx_pld_rst_n]] > 0 } {
  set_max_delay -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_10g_krfec_tx_pld_rst_n] 50ns
  set_min_delay -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_10g_krfec_tx_pld_rst_n] -50ns
}

# PCS liberty files have been modified to add a 0 recovery check 
# The two SDCs below bound tx_analogreset and rx_analogreset 
if { [get_collection_size [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_pma_txpma_rstb]] > 0 } {
  set_max_delay -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_pma_txpma_rstb] 20ns
  set_min_delay -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_pma_txpma_rstb] -10ns
}

if { [get_collection_size [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_pma_rxpma_rstb]] > 0 } {
  set_max_delay -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_pma_rxpma_rstb] 20ns
  set_min_delay -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_pma_rxpma_rstb] -10ns
}


# Create a set of all asynchronous signals to be looped over for setting false paths
set altera_xcvr_native_a10_async_signals {
  pld_10g_krfec_rx_pld_rst_n
  pld_10g_krfec_rx_clr_errblk_cnt
  pld_10g_rx_clr_ber_count
  pld_10g_tx_diag_status
  pld_10g_tx_bitslip
  pld_8g_g3_rx_pld_rst_n
  pld_8g_a1a2_size
  pld_8g_bitloc_rev_en
  pld_8g_byte_rev_en
  pld_8g_encdt
  pld_8g_tx_boundary_sel
  pld_8g_rxpolarity
  pld_pmaif_rx_pld_rst_n
  pld_bitslip
  pld_rx_prbs_err_clr
  pld_polinv_tx
  pld_polinv_rx
}

if { [ info exists altera_xcvr_native_a10_async_xcvr_pins ] } {
  unset altera_xcvr_native_a10_async_xcvr_pins
}

# Set false paths for each item in the set
foreach altera_xcvr_native_a10_async_signale_name $altera_xcvr_native_a10_async_signals {
  set altera_xcvr_native_a10_async_xcvr_pins [get_pins -nowarn -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|${altera_xcvr_native_a10_async_signale_name}*]
  if { [get_collection_size $altera_xcvr_native_a10_async_xcvr_pins] > 0 } {
    set_false_path -to $altera_xcvr_native_a10_async_xcvr_pins
  }
}

# pld_10g_rx_align_clr pin has two timing arcs; one w.r.t rx_coreclkin and the other w.r.t rx_pma_clk (case:294191)
# The arc w.r.t rx_pma_clk is asynchronous, distinguishing the arcs based on destination register name 
# To Node: pld_10g_rx_align_clr_reg.reg -> rx_pma_clk 
# To Node: pld_10g_rx_align_clr_fifo.reg -> rx_coreclkin 
set altera_xcvr_native_a10_async_xcvr_pins [get_pins -nowarn -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_10g_rx_align_clr*]
if {[get_collection_size $altera_xcvr_native_a10_async_xcvr_pins] > 0} {
  set_false_path -to *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*inst_twentynm_hssi_10g_rx_pcs~pld_10g_rx_align_clr_reg.reg
}

# For TX burst enable, even though its an asynchronous signal, set a bound, since we need the fitter to place it some-what close to the periphery for interlaken
set altera_xcvr_native_a10_async_xcvr_pins [get_pins -nowarn -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_10g_tx_burst_en*]
if { [get_collection_size $altera_xcvr_native_a10_async_xcvr_pins] > 0 } {
  set_max_delay -to $altera_xcvr_native_a10_async_xcvr_pins 20ns
  set_min_delay -to $altera_xcvr_native_a10_async_xcvr_pins -20ns
}

# When using the PRBS Error Accumulation logic, set multicycle constraints to reduce routing effor and congestion.  Also false path the asynchronous resets
if { [get_collection_size   [get_registers -nowarn *xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators\|rx_prbs_err_snapshot*]] > 0 } {
  set_max_delay       -from [get_registers *xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators\|rx_prbs_err_snapshot*] \
                      -to   [get_registers *xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators\|avmm_prbs_err_count*] \
                      15           
  set_min_delay       -from [get_registers *xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators\|rx_prbs_err_snapshot*] \
                      -to   [get_registers *xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators\|avmm_prbs_err_count*] \
                      -8           

  set_false_path      -through [get_pins -compatibility_mode  *xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators\|rx_clk_reset_sync*sync_r*clrn] \
                      -to      [get_registers *xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators\|rx_clk_reset_sync*sync_r[?]]
  set_false_path      -from    [get_registers *xcvr_native*optional_chnl_reconfig_logic*avmm_csr_enabled*embedded_debug_soft_csr*prbs_reg*] \
                      -to      [get_registers *xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators\|rx_clk_prbs_reset_sync*sync_r[?]]
}

# When the PIPE Retry circuit is enabled for Gen2, include the following SDC constraint
if { [get_collection_size   [get_registers -nowarn *xcvr_native*alt_xcvr_native_pipe_retry*hv_sync_retry_rate*]] > 0 } {
  if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
    set altera_xcvr_native_a10_pld_rate [get_pins -nowarn -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_rate*]
    if { [get_collection_size $altera_xcvr_native_a10_pld_rate] > 0 } {
      set_false_path -to $altera_xcvr_native_a10_pld_rate
    }
  }

  set_false_path -through [get_pins -nowarn -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*pld_test_data*]  \
                 -to      [get_registers *xcvr_native*alt_xcvr_native_pipe_retry*pma_pld_rate_sync[0]]
  set_false_path -through [get_pins -nowarn -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*pld_test_data*] \
                 -to      [get_registers *xcvr_native*alt_xcvr_native_pipe_retry*pma_pld_rate_sync[1]]
  set_false_path -to      [get_registers *xcvr_native*alt_xcvr_native_pipe_retry*tx_digitalreset_pclk_inst*sync_r[*]]
  set_false_path -to      [get_registers *xcvr_native*alt_xcvr_native_pipe_retry*tx_digitalreset_hv_inst*sync_r[*]]
  set_max_delay  -from    [get_registers *xcvr_native*alt_xcvr_native_pipe_retry*hv_sync_vec_pipe_rate*] \
                 -to      [get_registers *xcvr_native*alt_xcvr_native_pipe_retry*hv_sync_retry_rate*] 8
  set_min_delay  -from    [get_registers *xcvr_native*alt_xcvr_native_pipe_retry*hv_sync_vec_pipe_rate*] \
                 -to      [get_registers *xcvr_native*alt_xcvr_native_pipe_retry*hv_sync_retry_rate*] -4
}

if { [get_collection_size [get_registers -nowarn *xcvr_native*g_pipe_rate_g1_g3*int_pipe_rate_sync[*]]] > 0 } {
  set_min_delay -to [get_registers -nowarn *xcvr_native*g_pipe_rate_g1_g3*int_pipe_rate_sync[0]] -4 
  set_max_delay -to [get_registers -nowarn *xcvr_native*g_pipe_rate_g1_g3*int_pipe_rate_sync[0]] 12

  set_min_delay -to [get_registers -nowarn *xcvr_native*g_pipe_rate_g1_g3*int_pipe_rate_sync[1]] -4 
  set_max_delay -to [get_registers -nowarn *xcvr_native*g_pipe_rate_g1_g3*int_pipe_rate_sync[1]] 12
}

if { [get_collection_size [get_registers -nowarn *xcvr_native*altera_xcvr_native_pcie_dfe_ip*pcie_rate*]] > 0 } {
  set_min_delay -to [get_registers -nowarn *xcvr_native*altera_xcvr_native_pcie_dfe_ip*pcie_rate[*]] -4
  set_max_delay -to [get_registers -nowarn *xcvr_native*altera_xcvr_native_pcie_dfe_ip*pcie_rate[*]] 30

  set_min_delay -to [get_registers -nowarn *xcvr_native*altera_xcvr_native_pcie_dfe_ip*pcie_rate_sync[0]] -4
  set_max_delay -to [get_registers -nowarn *xcvr_native*altera_xcvr_native_pcie_dfe_ip*pcie_rate_sync[0]] 30

  set_min_delay -to [get_registers -nowarn *xcvr_native*altera_xcvr_native_pcie_dfe_ip*pcie_rate_sync[1]] -4
  set_max_delay -to [get_registers -nowarn *xcvr_native*altera_xcvr_native_pcie_dfe_ip*pcie_rate_sync[1]] 30
}

