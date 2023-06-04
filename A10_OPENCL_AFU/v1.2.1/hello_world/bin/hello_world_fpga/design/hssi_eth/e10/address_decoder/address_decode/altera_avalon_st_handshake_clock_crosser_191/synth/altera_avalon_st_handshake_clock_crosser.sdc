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


# (C) 2001-2018 Intel Corporation. All rights reserved.
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


# $File: //acds/main/ip/avalon_st/altera_avalon_st_handshake_clock_crosser/altera_avalon_st_handshake_clock_crosser.sdc $
# $Revision: #1 $
# $Date: 2014/04/09 $
# $Author: kespence $
#------------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Altera timing constraints for Avalon clock domain crossing (CDC) paths.
# The purpose of these constraints is to remove the false paths and replace with timing bounded 
# requirements for compilation.
#
# ***Important note *** 
#
# The clocks involved in this transfer must be kept synchronous and no false path
# should be set on these paths for these constraints to apply correctly.
# -----------------------------------------------------------------------------

set crosser_entity "altera_avalon_st_clock_crosser:"
set_max_delay -from [get_registers *${crosser_entity}*|in_data_buffer* ] -to [get_registers *${crosser_entity}*|out_data_buffer* ] 100
set_min_delay -from [get_registers *${crosser_entity}*|in_data_buffer* ] -to [get_registers *${crosser_entity}*|out_data_buffer* ] -100

set sync_entity "altera_avalon_st_clock_crosser:*|altera_std_synchronizer_nocut:"
set_max_delay -from [get_registers *${crosser_entity}* ] -to [get_registers *${sync_entity}*|din_s1 ] 100
set_min_delay -from [get_registers *${crosser_entity}* ] -to [get_registers *${sync_entity}*|din_s1 ] -100

foreach_in_collection list_of_out_data_buffers [get_registers *${crosser_entity}*|out_data_buffer\[0\] ] {
set regname [get_register_info -name $list_of_out_data_buffers]
regsub {\[0\]} $regname {*} regname
set_net_delay -from [get_registers *${crosser_entity}*|in_data_buffer* ] -to [get_registers $regname] -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8
}

foreach_in_collection list_in_data_toggle [ get_registers *${crosser_entity}*|in_data_toggle ] { 
   set in_flop [ get_register_info -name $list_in_data_toggle ] 
   # replace last occurence of string
   set in_sync_path [ regsub "(.*)(in_data_toggle)" $in_flop "\\1" ]
   set in_to_out_din_s1 ""
   set in_to_out_sync_din_s1 [ get_registers -nowarn [ append in_to_out_din_s1 $in_sync_path "in_to_out_synchronizer|din_s1" ] ]
   
   # check for the presence of din_s1 and set the net_delay after that
   if { [ expr { [ llength [ query_collection -report -all $in_to_out_sync_din_s1 ] ] > 0 } ] } { 
      set_net_delay -from [ get_register_info -name $list_in_data_toggle ] -to [ get_register_info -name $in_to_out_sync_din_s1 ] -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8  
   }
} 

foreach_in_collection list_out_data_toggle_flopped [ get_registers *${crosser_entity}*|out_data_toggle_flopped ] { 
   set out_flop [ get_register_info -name $list_out_data_toggle_flopped ] 
   # replace last occurence of string
   set out_sync_path [ regsub "(.*)(out_data_toggle_flopped)" $out_flop "\\1" ]
   set out_to_in_din_s1 ""
   set out_to_in_sync_din_s1 [ get_registers -nowarn [ append out_to_in_din_s1 $out_sync_path "out_to_in_synchronizer|din_s1" ] ]

   # check for the presence of din_s1 and set the net_delay after that
   if { [ expr { [ llength [ query_collection -report -all $out_to_in_sync_din_s1 ] ]  > 0 } ] } { 
      set_net_delay -from [ get_register_info -name $list_out_data_toggle_flopped ] -to [ get_register_info -name $out_to_in_sync_din_s1 ]   -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8  
   }
} 


# -----------------------------------------------------------------------------
# This procedure constrains the skew between the token and data bits, and should
# be called from the top level SDC, once per instance of the clock crosser.
#
# The hierarchy path to the handshake clock crosser instance is required as an 
# argument.
#
# In practice, the token and data bits tend to be placed close together, making
# excessive skew less of an issue.
# -----------------------------------------------------------------------------
proc constrain_alt_handshake_clock_crosser_skew { path } {

    set in_regs  [ get_registers $path|*altera_avalon_st_clock_crosser*|in_data_buffer* ] 
    set out_regs [ get_registers $path|*altera_avalon_st_clock_crosser*|out_data_buffer* ] 

    set in_regs [ add_to_collection $in_regs  [ get_registers $path|*altera_avalon_st_clock_crosser*|in_data_toggle ] ]
    set out_regs [ add_to_collection $out_regs [ get_registers $path|*altera_avalon_st_clock_crosser:*|altera_std_synchronizer_nocut:in_to_out_synchronizer|din_s1 ] ]

    set_max_skew -from $in_regs -to $out_regs -get_skew_value_from_clock_period dst_clock_period -skew_value_multiplier 0.8
}

