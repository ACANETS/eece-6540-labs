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


# $Id$
# $Revision$
# $Date$
#-------------------------------------------------------------------------------
# TimeQuest constraints to cut all false timing paths across asynchronous 
# clock domains. 

set_false_path -from [get_pins -no_case -compatibility_mode *SPIPhy_MOSIctl\|stsourcedata*\|*] -to [get_registers *]
set_false_path -from [get_pins -no_case -compatibility_mode *SPIPhy_altera_avalon_st_idle_inserter\|received_esc*\|*] -to [get_pins -no_case -compatibility_mode *SPIPhy_MISOctl\|rdshiftreg*\|*]
