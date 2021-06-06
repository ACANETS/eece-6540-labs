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


# ===============================================================================
#
# Script name: alt_em10g32_clock_crosser_timing_info.tcl
# 
# To run this script in Quartus, go to Settings -> Category: TimeQuest Timing Analyzer,
# locate this script's location under "Tcl Script File name" by clicking "...".
# Click OK, and run full compilation.
#
# Alternatively, you may run the script by launching TimeQuest Timing Analyzer, 
# create a timing netlist first, then go to Script -> Run Tcl Script..., and  
# locate this script's location.
#
# ===============================================================================

set min_net_delay {{0} {0} {0}}
set max_net_delay {{3.0} {3.0} {3.0}}


# ========================================================================
# 
# Procedure  : compare_delay
# Input      : array, node name, minimum delay, maximum delay, file handle
# Output     : return 1 if pass, 0 if fail
# Description: Check whether the delay of specified node is longer than the 
#              specified minimum and maximum delay. It will dump out the 
#              summary and list of all failing paths to a file.
#
#              Use get_timing_info to produce the array needed by this function.
#
# ========================================================================
proc compare_delay {timing_info_list node_name min_delay max_delay fh} {
	array set timing_info $timing_info_list
	set fail_min_counter 0
	set fail_max_counter 0
	set pass_min_counter 0
	set pass_max_counter 0
	foreach info [lsort [array names timing_info]] {
		set info_list [split $info ","]
		set operating_condition [lindex $info_list 0]
		set node_path [lindex $info_list 1]
		set min_slack [lindex $info_list 2]
		set max_slack [lindex $info_list 3]

		
		if {[string match $node_name $node_path]} {
			if {($min_slack <= $max_delay)} {
				incr pass_min_counter
			} else {
				puts $fh "inst: $node_path"
				puts $fh "Model: $operating_condition"
				puts $fh "Failed min timing, delay: $min_slack does not fall within range of $min_delay and $max_delay.\n"
				incr fail_min_counter
			}
			if {($max_slack <= $max_delay)} {
				incr pass_max_counter
			} else {
				puts $fh "inst: $node_path"
				puts $fh "Model: $operating_condition"
				puts $fh "Failed max timing, delay: $max_slack does not fall within range of $min_delay and $max_delay.\n"
				incr fail_max_counter
			}
		}
	}
	puts $fh "Total number of paths for node $node_name that pass minimum delay timing: $pass_min_counter"
	puts $fh "Total number of paths for node $node_name that fail minimum delay timing: $fail_min_counter"
	puts $fh "Total number of paths for node $node_name that pass maximum delay timing: $pass_max_counter"
	puts $fh "Total number of paths for node $node_name that fail maximum delay timing: $fail_max_counter\n"
	
	if {($fail_min_counter == 0) && ($fail_max_counter == 0)} {
		return 1
	} else {
		return 0
	}
}

# ========================================================================
# 
# Procedure  : compare_timing
# Input      : array, file handle
# Output     : return 1 if pass, 0 if fail
# Description: Check whether the delay of data_valid paths is longer than 
#              data path. It will dump out the summary and list of all failing 
#              paths to a file.
#
#              Use get_timing_info to produce the array needed by this function.
#
# ========================================================================
proc compare_timing {timing_info_list fh} {
	array set timing_info $timing_info_list
	set fail_counter 0
	set pass_counter 0
	set operating_condition 0
	set expected_margin 3.0
	
	foreach toggle_info [lsort [array names timing_info]] {
		set toggle_info_list [split $toggle_info ","]
		if {$operating_condition != [lindex $toggle_info_list 0]} {
			set operating_condition [lindex $toggle_info_list 0]
			set_operating_conditions $operating_condition
			update_timing_netlist
		}
		set node_path [lindex $toggle_info_list 1]
		if {[string match *|in_data_toggle* $node_path]} {
			if {[string match *|in_data_toggle~DUPLICATE $node_path]} {
				regsub {in_data_toggle~DUPLICATE} $node_path "" inst_name
			} else {
				regsub {in_data_toggle} $node_path "" inst_name
			}
			set a1 [report_clock_delay $inst_name in_data_toggle "-min_path"]
			set a2 [lindex $toggle_info_list 2]
			set a3 [report_clock_delay $inst_name "out_data_toggle_sync_reg[0]" "-min_path"]
			set b1 [report_clock_delay $inst_name in_data_buffer* ""]
			set b2 [report_path_delay $inst_name in_data_buffer* out_data_buffer* ""]
			set b3 [report_clock_delay $inst_name out_data_buffer* ""]
			
			if { ($a1 > 0) && ($a2 > 0) && ($a3 > 0) && ($b1 > 0) && ($b2 > 0) && ($b3 > 0)} {
				set toggle_min_slack [expr $a1 + $a2 + $a3]
				set data_max_slack [expr $b1 + $b2 + $b3]
				set margin [expr $toggle_min_slack - $data_max_slack + $expected_margin]
				if {$margin > 0} {
					incr pass_counter
				} else {
					puts $fh "inst: $inst_name"
					puts $fh "Model: $operating_condition"
					puts $fh "Failed: Margin of $margin is less than $expected_margin, min toggle delay is $toggle_min_slack, max data delay is $data_max_slack\n"
					incr fail_counter
				}
			# } else {
				# puts $fh "Debug: $inst_name"
				# puts $fh "Debug: a1=$a1,a2=$a2,a3=$a3,b1=$b1,b2=$b2,b3=$b3"
			}
			
		}
	}
	puts $fh "Total pass: $pass_counter"
	puts $fh "Total fail: $fail_counter\n"
	
	if {$fail_counter == 0} {
		return 1
	} else {
		return 0
	}
}

# ========================================================================
# 
# Procedure  : report_path_delay
# Input      : instance name, source node, destination node, report_path argument
# Output     : delay
# Description: Report the longest maximum delay of the given path.
#              Can pass in -min_path argument to report the longest minimum 
#              delay.
#              e.g. To find out the maximum delay of inst_a|in_data_valid to 
#                   inst_a|out_data_valid
#                   report_path_delay inst_a| in_data_valid out_data_valid ""
#              e.g. To find out the minimum delay of inst_b|reg to inst_b|reg_sync
#                   report_path_delay inst_b| reg reg_sync "-min_path"
#
# ========================================================================
proc report_path_delay {inst_name from_node to_node min} {
	set from $inst_name$from_node
	set to $inst_name$to_node
	set kprs [get_keepers -nowarn $from]
	if {[llength [query_collection -report -all $kprs]]} {
		set list [report_path -npaths 1000 $min -from $from -to $to]
		set delay [lindex $list 1]
		return $delay
	} else {
		return 0
	}
}

# ========================================================================
# 
# Procedure  : report_clock_delay
# Input      : instance name, node name, report_path argument
# Output     : delay
# Description: Report the longest maximum delay of clock path to the clock pin of 
#              specified node. Can pass in -min_path argument to report the longest 
#              minimum delay.
#              e.g. To find out the maximum delay of clock path to inst_a|in_data_valid*
#                   report_clock_delay inst_a| in_data_valid ""
#              e.g. To find out the minimum delay of clock path to inst_b|reg
#                   report_clock_delay inst_b| reg "-min_path"
#
# ========================================================================
proc report_clock_delay {inst_name node_name min} {
	set clk |clk
	set to "$inst_name$node_name$clk"
	set pins [get_pins -nowarn $to]
	if {[llength [query_collection -report -all $pins]]} {
		set list [report_path -npaths 1000 $min -to [get_pins $to]]
		set delay [lindex $list 1]
		return $delay
	} else {
		return 0
	}
}

# ========================================================================
# 
# Procedure  : get_timing_info
# Input      : none
# Output     : node information array
# Description: Obtain all delays of critical paths in clock crosser for 
#              all operating conditions, and return this information in
#              the form of array, as well as dumping out this information
#              to alt_em10g32_clock_crosser_timing_path.csv. The sequence of 
#              returned information is:
#              operating condition, source node, destination node, minimum 
#              delay, maximum delay
#
# ========================================================================

proc get_timing_info {} {

	set filename "alt_em10g32_clock_crosser_timing_path.csv"
	puts "Generating output file $filename"

	if { [catch { open $filename w } fh] } {
		post_message -type error "Couldn't open file: $fh"
	} else {
		puts $fh "Auto generated from alt_em10g32_clock_crosser_timing_info.tcl\n"
	}

	global npaths
	global from_path
	global to_path

	set npaths 10000
	set from_path {{*alt_em10g32_clock_crosser:*|in_data_toggle} {*alt_em10g32_clock_crosser:*|out_data_toggle_flopped} {*alt_em10g32_clock_crosser:*|in_data_buffer*}}
	set to_path {{*alt_em10g32_clock_crosser:*|altera_std_synchronizer_nocut:synchronizer_nocut_forward_sync|din_s1} {*alt_em10g32_clock_crosser:*|altera_std_synchronizer_nocut:synchronizer_nocut_backward_sync|din_s1} {*alt_em10g32_clock_crosser:*|out_data_buffer*}}
	array set node_info_list {}
	
	foreach operating_condition [get_available_operating_conditions] {
		set_operating_conditions $operating_condition
        update_timing_netlist
		
		set i 0
		foreach from_p $from_path {
			puts $fh "Node: $from_p"
			puts $fh "Model,Minimum delay,Maximum delay,From,To"
			if { [catch { eval get_path -npaths $npaths -min_path -from "$from_p" -to "[lindex $to_path $i]"} path_col] } {
				post_message -type error $path_col
				return
			}

			foreach_in_collection path_obj $path_col {
				
				set from [get_node_info -name [get_path_info -from $path_obj]]
				set to [get_node_info -name [get_path_info -to $path_obj]]

				set min_delay [get_path_info -slack $path_obj]
				if { [catch { eval get_path -from $from -to $to} path_col_2] } {
					post_message -type error $path_col_2
					return
				}
				foreach_in_collection path_obj_2 $path_col_2 {
					set max_delay [expr {abs([get_path_info -slack $path_obj_2])} ]

					puts $fh "$operating_condition,$min_delay,$max_delay,$from,$to"
					set node_info [join [list $operating_condition $from $min_delay $max_delay] ","]
					if {![info exists node_info_list($node_info)]} {
						set node_info_list($node_info) {}
					}
				}
			}
			puts $fh "\n"
			incr i
		}
	}

	catch { close $fh }
	puts "File $filename created"
	return [array get node_info_list]
}

# create_timing_netlist

array set timing_info_list [get_timing_info]

set fh [open alt_em10g32_clock_crosser_failing_path.rpt w]
puts $fh "Auto generated from alt_em10g32_clock_crosser_timing_info.tcl\n"
puts $fh "Stage 1: Check whether the maximum and minimum delay of a given path falls within a range of acceptable delay."

set in_toggle_pass [compare_delay [array get timing_info_list] *|in_data_toggle* [lindex $min_net_delay 0] [lindex $max_net_delay 0] $fh]
set out_toggle_pass [compare_delay [array get timing_info_list] *|out_data_toggle_flopped* [lindex $min_net_delay 1] [lindex $max_net_delay 1] $fh]

puts $fh "Stage 2: Check whether the delay of data_valid paths is longer than data paths."
set timing_pass [compare_timing [array get timing_info_list] $fh]

if {$in_toggle_pass && $out_toggle_pass && $timing_pass} {
	puts "No failing paths found. All alt_em10g32_clock_crosser timing passed."
	puts $fh "No failing paths found. All alt_em10g32_clock_crosser timing passed."
} else {
	puts "alt_em10g32_clock_crosser timing failed. Please refer to the generated report for list of failing paths."
	puts $fh "alt_em10g32_clock_crosser timing failed."
}

close $fh
puts "File alt_em10g32_clock_crosser_failing_path.rpt created"
# delete_timing_netlist





