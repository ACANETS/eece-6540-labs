# Legal Notice: (C)2019 Altera Corporation. All rights reserved.  Your
# use of Altera Corporation's design tools, logic functions and other
# software and tools, and its AMPP partner logic functions, and any
# output files any of the foregoing (including device programming or
# simulation files), and any associated documentation or information are
# expressly subject to the terms and conditions of the Altera Program
# License Subscription Agreement or other applicable license agreement,
# including, without limitation, that your use is for the sole purpose
# of programming logic devices manufactured by Altera and sold by Altera
# or its authorized distributors.  Please refer to the applicable
# agreement for further details.

#**************************************************************
# Timequest JTAG clock definition
#   Uncommenting the following lines will define the JTAG
#   clock in TimeQuest Timing Analyzer
#**************************************************************

#create_clock -period 10MHz {altera_reserved_tck}
#set_clock_groups -asynchronous -group {altera_reserved_tck}

#**************************************************************
# Set TCL Path Variables 
#**************************************************************

set 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a:*
set 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_nios2_oci:the_tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_nios2_oci
set 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci_break 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_nios2_oci_break:the_tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_nios2_oci_break
set 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_ocimem 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_nios2_ocimem:the_tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_nios2_ocimem
set 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci_debug 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_nios2_oci_debug:the_tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_nios2_oci_debug
set 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_wrapper 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_debug_slave_wrapper:the_tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_debug_slave_wrapper
set 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_jtag_tck 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_debug_slave_tck:the_tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_debug_slave_tck
set 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_jtag_sysclk 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_debug_slave_sysclk:the_tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_debug_slave_sysclk
set 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci_path 	 [format "%s|%s" $tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a $tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci]
set 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci_break_path 	 [format "%s|%s" $tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci_path $tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci_break]
set 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_ocimem_path 	 [format "%s|%s" $tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci_path $tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_ocimem]
set 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci_debug_path 	 [format "%s|%s" $tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci_path $tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci_debug]
set 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_jtag_tck_path 	 [format "%s|%s|%s" $tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci_path $tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_wrapper $tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_jtag_tck]
set 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_jtag_sysclk_path 	 [format "%s|%s|%s" $tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci_path $tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_wrapper $tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_jtag_sysclk]
set 	tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_jtag_sr 	 [format "%s|*sr" $tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_jtag_tck_path]

#**************************************************************
# Set False Paths
#**************************************************************

set_false_path -from [get_keepers *$tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci_break_path|break_readreg*] -to [get_keepers *$tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_jtag_sr*]
set_false_path -from [get_keepers *$tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci_debug_path|*resetlatch]     -to [get_keepers *$tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_jtag_sr[33]]
set_false_path -from [get_keepers *$tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci_debug_path|monitor_ready]  -to [get_keepers *$tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_jtag_sr[0]]
set_false_path -from [get_keepers *$tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci_debug_path|monitor_error]  -to [get_keepers *$tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_jtag_sr[34]]
set_false_path -from [get_keepers *$tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_ocimem_path|*MonDReg*] -to [get_keepers *$tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_jtag_sr*]
set_false_path -from *$tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_jtag_sr*    -to *$tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_jtag_sysclk_path|*jdo*
set_false_path -from *sld_jtag_hub:*|irf_reg* -to *$tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_jtag_sysclk_path|ir*
set_false_path -from *sld_jtag_hub:*|sld_shadow_jsm:shadow_jsm|state[1] -to *$tcm_nios2_gen2_0_altera_nios2_gen2_unit_191_dbuc52a_oci_debug_path|monitor_go
