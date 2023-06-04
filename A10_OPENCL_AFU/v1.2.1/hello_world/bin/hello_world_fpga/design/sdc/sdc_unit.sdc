## Generated SDC file "ccip_fabric_top.sdc"

## Copyright (C) 1991-2014 Altera Corporation
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
## VERSION "Version 13.1.4 Build 182 03/12/2014 SJ Full Version"

## DATE    "Tue Apr  7 02:01:25 2015"

##
## DEVICE  "5SGXEA7N1F45C2"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {Clk_16UI} -period 2.500 -waveform { 0.000 1.250 } [get_ports {Clk_16UI}]
create_clock -name {Clk_32UI} -period 5.000 -waveform { 0.000 2.500 } [get_ports {Clk_32UI}] 
create_clock -name {Clk_AVL0} -period 4.000 -waveform { 0.000 2.000 } [get_ports {Clk_AVL0}] 
create_clock -name {Clk_AVL1} -period 4.000 -waveform { 0.000 2.000 } [get_ports {Clk_AVL1}] 
create_clock -name {Clk_100} -period 10.000 -waveform { 0.000 5.000 } [get_ports {Clk_100}] 
create_clock -name {Clk_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {Clk_50}] 
set_clock_groups -exclusive -group [get_clocks {Clk_16UI Clk_32UI, Clk_100, Clk_50}]
set_clock_groups -asynchronous -group [get_clocks {Clk_AVL0}]
set_clock_groups -asynchronous -group [get_clocks {Clk_AVL1}]


create_generated_clock -name {pmbus_clk} -source [get_nets {Clk_100*}] -divide_by 8 [get_nets {*inst_ptmgr_*|ffs_ck100_vl3_ck100_cnt[2]}]
create_generated_clock -name tckcore -source [get_ports {Clk_32UI}] -divide_by 6 [get_nets {inst_ccip_fabric_top|inst_fme_top|inst_PR_cntrl|inst_sec_block|i_sec_ijtagif|i_ijt_tckm|xtck}]

set_multicycle_path -setup -start -from [get_registers {c32ui_SoftReset_n_q*}] 2
set_multicycle_path -hold  -start -from [get_registers {c32ui_SoftReset_n_q*}] 1

set_false_path -to [get_registers *inst_PR_cntrl|tdocore_T1*]

#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

