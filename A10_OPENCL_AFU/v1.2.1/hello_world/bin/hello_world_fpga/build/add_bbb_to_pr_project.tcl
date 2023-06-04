# (C) 2017 Intel Corporation. All rights reserved.
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

proc add_bbb_assignments { } {
	#ccip avmm shim
	set CCIP_AVMM_SRC "./BBB_ccip_avmm"
	source "$CCIP_AVMM_SRC/hw/par/ccip_avmm_addenda.qsf"
	
	#mpf
	set_global_assignment -name VERILOG_MACRO "MPF_PLATFORM_DCP_PCIE=1"
	set CCI_MPF_SRC "./BBB_cci_mpf"
	source "$CCI_MPF_SRC/hw/par/qsf_cci_mpf_PAR_files.qsf"
}

project_open -revision afu_default dcp

add_bbb_assignments
export_assignments

set_current_revision afu_base
add_bbb_assignments
export_assignments
set_current_revision afu_import
add_bbb_assignments
export_assignments
project_close
