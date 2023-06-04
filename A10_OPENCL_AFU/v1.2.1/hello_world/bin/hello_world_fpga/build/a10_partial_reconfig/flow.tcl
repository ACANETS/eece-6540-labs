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

set p4_revision(main) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]


#    Arria 10 Partial Reconfiguration Flow Script
#
#    This template, once configured for your design, can be used to invoke the
#    partial reconfiguration flow for an Arria 10 design. To use this template
#    customize the settings in the setup.tcl file  to specify the 
#    revision names for each PR implementation along with the partitions they implement.
#    The partition name is the name assigned to the partition using the PARTITION
#    assignment in the Quartus Settings File (.qsf).
#
#    You can run this script using qpro_sh -t a10_partial_reconfig/flow.tcl
#
#    You can run this script in 1 of 5 modes:
#       1) Compile all implementations and the base revision.
#          This is the default mode, or can be explicitly set using the -all
#          argument.
#       2) Compile a specific implementation identified by its implementation 
#          revision name. A specific implementation can be identified using the 
#          -impl $name argument. The $name argument passed to -impl 
#          matches the implementation revision name used when defining 
#          the configuration with the define_pr_revision procedure.
#       3) Compile all implementations but do not compile the base revision.
#          This is enabled using the -all_impl argument.
#       4) Compile only the base revision and do not compile any of the PR
#          implementation revisions. This is enabled using the -base argument.
#       5) Check the configuration of the script and then exit.
#          This is enabled using the -check argument.
#

###############################################################################
# IMPLEMENTATION DETAILS
###############################################################################
global PROJECT_NAME
global BASE_REVISION_NAME
global IMPL_REV_BLOCK_IMPORT_MAP
set IMPL_REV_BLOCK_IMPORT_MAP [dict create]
global BASE_REVISION_BLOCK_NAMES
global BASE_REVISION_OUTPUT_DIR
global options

global CURRENT_SCRIPT
set CURRENT_SCRIPT [info script]

proc my_export_partition {partition snapshot qdb_filename } {
	execute_module -dont_export_assignments -tool cdb -args "--export_block $partition --snapshot $snapshot --file $qdb_filename"
}

proc define_project {project_name} {
	global PROJECT_NAME
	if {[string compare $PROJECT_NAME ""] != 0}  {
		post_message -type error "The project name has already been defined. Ensure define_project is only called once."
		qexit -error
	}
	
	set PROJECT_NAME $project_name
}

proc define_base_revision {rev_name} {
	global BASE_REVISION_NAME
	if {[string compare $BASE_REVISION_NAME ""] != 0}  {
		post_message -type error "The base revision name has already been defined. Ensure define_base_revision is only called once."
		qexit -error
	}
	
	set BASE_REVISION_NAME $rev_name
}

proc define_pr_impl_partition {args} {
	global PROJECT_NAME
	global IMPL_REV_BLOCK_IMPORT_MAP

	set impl_rev_name ""
	set partition_name ""

	#check legality and get rev name, there can be one and only one -impl_rev_name argument.
	for {set i 0} {$i < [llength $args]} {incr i 2} {
		set arg_name [lindex $args $i]
		set arg_val [lindex $args $i+1]

		if {$arg_name == "-impl_rev_name"} {
			if {$impl_rev_name != ""} {
					post_message -type error "The argument impl_rev_name was passed multiple times to define_pr_impl_partition. It can only be passed once."
					qexit -error
			}
			set impl_rev_name $arg_val
		} elseif {$arg_name == "-partition_name"} {
				# 
		} else {
				post_message -type error "The argument $arg_name passed to define_pr_impl_partition is not a recognized argument."
				qexit -error
		}
	}
	if {$impl_rev_name == ""} {
			post_message -type error "The required argument impl_rev_name was not supplied to define_pr_impl_revision."
	qexit -error
	}

	# Process the import blocks and complete the import map
	# First define the partition name
	for {set i 0} {$i < [llength $args]} {incr i 2} {
		set arg_name [lindex $args $i]
		set arg_val [lindex $args $i+1]

		if {$arg_name == "-partition_name"} {
			if {$partition_name != ""} {
				post_message -type error "The argument partition_name was passed multiple times to define_pr_impl_partition. It can only be passed once."
				qexit -error
			}
			set partition_name $arg_val
		}
	}
	if {$partition_name == ""} {
			post_message -type error "The required argument partition_name was not supplied to define_pr_impl_partition."
			qexit -error
	}
		
	dict set IMPL_REV_BLOCK_IMPORT_MAP $impl_rev_name $partition_name
		
}

proc initialize {skip_base_check} {
	global PROJECT_NAME
	global BASE_REVISION_NAME
	global IMPL_REV_BLOCK_IMPORT_MAP
	global BASE_REVISION_OUTPUT_DIR
	global BASE_REVISION_BLOCK_NAMES
	
	# Check that the setup was specified
	if {$PROJECT_NAME == ""} {
		post_message -type error "No project specified in the flow setup file."
		qexit -error
	}

	if {$BASE_REVISION_NAME == ""} {
		post_message -type error "No base revision name specified in the flow setup file."
		qexit -error
	}
	
	if {$skip_base_check == 1 && [dict size $IMPL_REV_BLOCK_IMPORT_MAP] == 0} {
		post_message -type error "No implementation revision names specified in the flow setup file."
		qexit -error
	}
	
	# Check that project exists
	if {[project_exists $PROJECT_NAME] == 0} {
		post_message -type error "No project named $PROJECT_NAME exists."
		post_message -type error "   Search path: [pwd]"
		qexit -error
	}
	
	# Check all revisions exist. Do this by checking for the existence of the QSF
	if {($skip_base_check == 0) && ([file exists "${BASE_REVISION_NAME}.qsf"] == 0)} {
		post_message -type error "No revision named ${BASE_REVISION_NAME}.qsf found."
		post_message -type error "   Search path: [pwd]"
		qexit -error
	}
      
        foreach rev [dict keys $IMPL_REV_BLOCK_IMPORT_MAP] {
		if {[file exists "${rev}.qsf"] == 0} {
			post_message -type error "No revision named ${rev}.qsf found."
			post_message -type error "   Search path: [pwd]"
			qexit -error
		}
	}
	
	# Open the base revision to check assignments
	if {($skip_base_check == 0)} {
		if { [catch {project_open $PROJECT_NAME -rev $BASE_REVISION_NAME} msg] } {
			puts $msg
			post_message -type error "Could not open project $PROJECT_NAME and revision $BASE_REVISION_NAME. Check the revision exists and is specified in the Quartus Project File (.qpf)."
			qexit -error
		}
		
		# Default to the current directory
		set BASE_REVISION_OUTPUT_DIR [pwd]
	
		# Get the project_output_dir assignment from the base revision
		foreach_in_collection asgn [get_all_global_assignments -name PROJECT_OUTPUT_DIRECTORY] {
			## Each element in the collection has the following
			## format: { {} {<Assignment name>} {<Assignment value>} {<Entity name>} {<Tag data>} }                                                                     
			set name   [lindex $asgn 1]                                                 
			set value  [lindex $asgn 2]                                                 
			set entity [lindex $asgn 3]                                                 
			set tag    [lindex $asgn 4]   	
			
			set BASE_REVISION_OUTPUT_DIR $value
		}	
	
		# Get all the PR partition assignments from the base revision
		set pr_partition_targets [list]
		foreach_in_collection asgn [get_all_instance_assignments -name PARTIAL_RECONFIGURATION_PARTITION ] {
			## Each element in the collection has the following
			## format: { {} {<Source>} {<Destination>} {<Assignment name>} {<Assignment value>} {<Entity name>} {<Tag data>} }                                          
			set from   [lindex $asgn 1]                                                 
			set to     [lindex $asgn 2]                                                 
			set name   [lindex $asgn 3]                                                 
			set value  [lindex $asgn 4]                                                 
			set entity [lindex $asgn 5]                                                 
			set tag    [lindex $asgn 6]                                                 
		
			
			if {($to != "root_partition") && ([string compare -nocase "on" $value] == 0)} {
				lappend pr_partition_targets $to
			}
		}	
	
		# Get all the partition assignments from the base revision
		set BASE_REVISION_BLOCK_NAMES [list]
		foreach_in_collection asgn [get_all_instance_assignments -name PARTITION] {
			## Each element in the collection has the following
			## format: { {} {<Source>} {<Destination>} {<Assignment name>} {<Assignment value>} {<Entity name>} {<Tag data>} }                                          
			set from   [lindex $asgn 1]                                                 
			set to     [lindex $asgn 2]                                                 
			set name   [lindex $asgn 3]                                                 
			set value  [lindex $asgn 4]                                                 
			set entity [lindex $asgn 5]                                                 
			set tag    [lindex $asgn 6]                                                 
		
			
			# Filter out root_partition partitions, and partitions that are not
			# PR partitions
			if {$value != "root_partition"} {
				if {[lsearch -exact $pr_partition_targets $to] != -1} {
					lappend BASE_REVISION_BLOCK_NAMES $value
				}
			}
		}
		
		# Check that the family is arria 10
		set value [get_global_assignment -name FAMILY]
		if {[lsearch -exact [list "ARRIA 10" "CYCLONE 10 GX"] [string toupper [get_dstr_string -family $value]]] == -1} {
			post_message -type error "The current family $value ([get_dstr_string -family $value]) is not supported by the a10_partial_reconfig flow script. This script only supports families: Arria 10."
			qexit -error
		}
	
		# Close the base revision
		project_close
	} else {
		# Set defaults
		set BASE_REVISION_OUTPUT_DIR [pwd]
		set BASE_REVISION_BLOCK_NAMES [list]
		
		# Set all blocks from IMPLs as the list of blocks
		set rev ""
		dict for {impl_rev_name block_name} $IMPL_REV_BLOCK_IMPORT_MAP {
			if {$rev == ""} {set rev $impl_rev_name}
		        if {[lsearch -exact $BASE_REVISION_BLOCK_NAMES $block_name] == -1} {
			   lappend BASE_REVISION_BLOCK_NAMES $block_name
			}
		}
		
		# Get the output files dir for the first revision
		if { [catch {project_open $PROJECT_NAME -rev $rev} msg] } {
			puts $msg
			post_message -type error "Could not open revision $rev. Check the revision exists and is specified in the Quartus Project File (.qpf)."
			qexit -error
		}
		
		# Get the project_output_dir assignment from the revision
		set BASE_REVISION_OUTPUT_DIR [pwd]
		foreach_in_collection asgn [get_all_global_assignments -name PROJECT_OUTPUT_DIRECTORY] {
			## Each element in the collection has the following
			## format: { {} {<Assignment name>} {<Assignment value>} {<Entity name>} {<Tag data>} }                                                                     
			set name   [lindex $asgn 1]                                                 
			set value  [lindex $asgn 2]                                                 
			set entity [lindex $asgn 3]                                                 
			set tag    [lindex $asgn 4]   	
			
			set BASE_REVISION_OUTPUT_DIR $value
		}
	
		project_close
	}
	
	# Check all implementation revisions
	foreach rev [dict keys $IMPL_REV_BLOCK_IMPORT_MAP] {
		# Open the revision to check for assignments
		if { [catch {project_open $PROJECT_NAME -rev $rev} msg] } {
			puts $msg
			post_message -type error "Could not open revision $rev. Check the revision exists and is specified in the Quartus Project File (.qpf)."
			qexit -error
		}
		
		
		# Get the project_output_dir assignment from the revision
		set rev_output_dir [pwd]
		foreach_in_collection asgn [get_all_global_assignments -name PROJECT_OUTPUT_DIRECTORY] {
			## Each element in the collection has the following
			## format: { {} {<Assignment name>} {<Assignment value>} {<Entity name>} {<Tag data>} }                                                                     
			set name   [lindex $asgn 1]                                                 
			set value  [lindex $asgn 2]                                                 
			set entity [lindex $asgn 3]                                                 
			set tag    [lindex $asgn 4]   	
			
			set rev_output_dir $value
		}
		if {($skip_base_check == 0)} {
			if {$rev_output_dir != $BASE_REVISION_OUTPUT_DIR} {
				post_message -type error "Output directory for revision $rev does not match output directory for base revision $BASE_REVISION_NAME. All output directories must be the same."
				qexit -error
			}
		}

		project_close
	}

}

proc print_pr_project_info {} {
	global PROJECT_NAME
	global BASE_REVISION_NAME
	global IMPL_REV_BLOCK_IMPORT_MAP
	global BASE_REVISION_BLOCK_NAMES
	global BASE_REVISION_OUTPUT_DIR

	puts "Arria 10 Partial Reconfiguration Flow"
	puts "-------------------------------------------------------------------------------"
	puts "   Project name                   : $PROJECT_NAME"
	puts "   Output directory               : $BASE_REVISION_OUTPUT_DIR"
	puts "   Base revision name             : $BASE_REVISION_NAME"
	puts "   Reconfigurable partition names : $BASE_REVISION_BLOCK_NAMES"

        dict for {impl_rev_name block_name} $IMPL_REV_BLOCK_IMPORT_MAP {
		puts "   Implementation Revision : $impl_rev_name"
		set blocks_for_impl [list]
		puts "      Reconfigurable Partition Name : $block_name"
		lappend blocks_for_impl $block_name
			
                if {[lsearch -exact $BASE_REVISION_BLOCK_NAMES $block_name] == -1} {
                        post_message -type error "Reconfigurable partition named $block_name does not exist in the base revision $BASE_REVISION_NAME."
                        post_message -type error "Existing partition names are: $BASE_REVISION_BLOCK_NAMES"
                        qexit -error
                }
			
		# Make sure all base blocks are defined
		foreach base_block $BASE_REVISION_BLOCK_NAMES {
			if {[lsearch -exact $blocks_for_impl $base_block] == -1} {
				post_message -type error "Required partition name $base_block does not exist in the PR implementation revision $impl_rev_name."
				post_message -type error "Required partition names are: $BASE_REVISION_BLOCK_NAMES"
				qexit -error
			}
		}
	}
}


proc compile_pr_revision_impl {impl_rev} {
	global PROJECT_NAME

     	# Open the project. It is closed at the end of the import blocks command.
	project_open $PROJECT_NAME -rev $impl_rev
	
        post_message -type info "Compiling PR implementation $impl_rev."
        execute_flow -compile 
	
	project_close
}


proc compile_base_revision {} {
	global PROJECT_NAME
	global BASE_REVISION_NAME

	project_open $PROJECT_NAME -rev $BASE_REVISION_NAME
	
	# Compile the base revision
	post_message -type info "Compiling base revision $BASE_REVISION_NAME from project $PROJECT_NAME."
	execute_module -dont_export_assignments -tool ipg -args "--generate_project_qsys_files"
	if {[file exists "post_ipgenerate_base_flow.tcl"]} {
		post_message -type info "Preparing to source post_ipgenerate_base_flow.tcl."
		source "post_ipgenerate_base_flow.tcl"
	}
        
        execute_module -dont_export_assignments -tool syn
	execute_module -dont_export_assignments -tool fit
        # Update FME ID MIF content
        exec python ../update_fme_ifc_id.py ..
        execute_module -dont_export_assignments -tool cdb -args "--update_mif"
	execute_module -dont_export_assignments -tool asm
	execute_module -dont_export_assignments -tool sta
	
	# export the root partition
	my_export_partition "root_partition" final "$BASE_REVISION_NAME.qdb"
	project_close
}


proc compile_all_pr_revisions {} {
	global BASE_REVISION_NAME
	global IMPL_REV_BLOCK_IMPORT_MAP

	# Make sure the QDB exists
	if {[file exists "$BASE_REVISION_NAME.qdb"] == 0} {
		post_message -type error "Could not find required file $BASE_REVISION_NAME.qdb."
		post_message -type error "   Search path: [pwd]"
		qexit -error
	}

	# Implement each PR revision
	foreach impl_rev [dict keys $IMPL_REV_BLOCK_IMPORT_MAP] {
		compile_pr_revision_impl $impl_rev
	}
}

proc compile_all_revisions {} {
	# Compile the base revision
	compile_base_revision
	
	# compile all PR implementations
	compile_all_pr_revisions
}

proc compile_pr_revision {requested_impl_name} {
	global PROJECT_NAME
	global BASE_REVISION_NAME
	global IMPL_REV_BLOCK_IMPORT_MAP

	# Find the desired PR implementation and then compile it
	dict for {impl_rev_name block_map} $IMPL_REV_BLOCK_IMPORT_MAP {
		
		if {[string compare $requested_impl_name $impl_rev_name] == 0} {
			# Compile the desired revision
			compile_pr_revision_impl $impl_rev_name
		
			return 1
		}
	}
	
	post_message -type error "Could not find an implementation revision named $requested_impl_name."
	qexit -error
}

proc cleanup {} {
	global PROJECT_NAME
	global BASE_REVISION_NAME
	global BASE_REVISION_OUTPUT_DIR

	
	# Open project using force to override old versions 
	project_open $PROJECT_NAME -rev $BASE_REVISION_NAME -force

	post_message -type info "Cleaning up project."
	
	# Clean up the project across all revisions. This also
	# closes the project. Catch any errors from this command to handle
	# old revisions
	catch {project_clean} msg
	puts $msg

	# Cleanup things not done by project_clean
	if {${BASE_REVISION_OUTPUT_DIR} != [pwd]} {
		file delete -force ${BASE_REVISION_OUTPUT_DIR}
	}
	file delete -force "${BASE_REVISION_NAME}.qdb"
}

###############################################################################
# MAINLINE
###############################################################################
proc main {} {
	global quartus
	global PROJECT_NAME
	global BASE_REVISION_NAME
	global options
	global CURRENT_SCRIPT

	set available_options {
		{ check "Check the script configuration then exit" }
		{ nobasecheck "Skip configuration checking (Internal Only)" }
		{ all "Compile all revisions" }
		{ base "Compile base revision" }
		{ all_impl "Compile all PR implementation revisions" }
		{ impl.arg "\#_ignore_\#" "Compile a specifically named implementation identified by the implementation revision name" }
		{ setup_script.arg "\#_ignore_\#" "Specify a script to use instead of running the define_pr_project in the script" }
	}
	
	# Load required packages
	load_package flow
	load_package design
	package require cmdline
	
	# Initialize
	set PROJECT_NAME ""
	set BASE_REVISION_NAME ""
	
	
	# Print some useful infomation
	post_message -type info "[file tail [info script]] version: $::p4_revision(main)"
	
	# Check arguments
	# Need to define argv for the cmdline package to work
	set argv0 "quartus_sh -t [info script]"
	set usage "\[<options>\]"
	
	set argument_list $quartus(args)
	msg_vdebug "CMD_ARGS = $argument_list"
	
	# Use cmdline package to parse options
	if [catch {array set options [cmdline::getoptions argument_list $available_options]} result] {
		if {[llength $argument_list] > 0 } {
			# This is not a simple -? or -help but an actual error condition
			post_message -type error "Illegal Options $argument_list"
			post_message -type error  [::cmdline::usage $available_options $usage]
			qexit -error
		} else {
			post_message -type info  "Usage:"
			post_message -type info  [::cmdline::usage $available_options $usage]
			qexit -success
		}
	}
	
	# Define the PR project
	set setup_script [file join [file dirname $CURRENT_SCRIPT] "setup.tcl"]
	if {$options(setup_script) != "#_ignore_#"} {
		set setup_script $options(setup_script)
	}
	
	post_message -type info "Using setup script [file normalize $setup_script]"
	if {[file exists $setup_script]} {
		source $setup_script
	} else {
		post_message -type error "Required setup script setup.tcl was not found."
		post_message -type error "   Search path: [file dirname [file normalize $CURRENT_SCRIPT]]"
		qexit -error
	}
	
	# Perform initial checks and initialize
	initialize $options(nobasecheck)
	
	# Print the info on the project. This also checks the project
	print_pr_project_info
	
	# Perform the required flow
	if {$options(check)} {
		# Do nothing
	
		post_message -type info "Successfully completed flow script check."
	} elseif {$options(base)} {
		cleanup
	
		# Compile a single revision
		compile_base_revision
		post_message -type info "Successfully completed base revision."
	} elseif {$options(impl) != "#_ignore_#"} {
		# Compile a single revision
		compile_pr_revision $options(impl)
	
		post_message -type info "Successfully completed A10 PR compile."
	} elseif {$options(all_impl)} {
		# Compile all PR implementation revisions. In this case do not cleanup
		
		compile_all_pr_revisions
		post_message -type info "Successfully completed A10 PR compile."
	} else {
		# Do a full compile
		cleanup
	
		compile_all_revisions
		post_message -type info "Successfully completed A10 PR compile."
	}
}

###############################################################################
# Prevent script from running from GUI
###############################################################################

if {($::quartus(nameofexecutable) == "quartus") || ($::quartus(nameofexecutable) == "quartus_pro") || ($::quartus(nameofexecutable) == "qpro")} {
	
	# When running from the Quartus GUI execute ourselves using execute_script
	post_message -type info "Preparing to run: $CURRENT_SCRIPT."
	if [catch {execute_script $CURRENT_SCRIPT -tool sh} result] {
		puts $result
		puts "Error occurred running $CURRENT_SCRIPT."
	} else {
		puts "Script $CURRENT_SCRIPT completed successfully."
	}
} elseif {($::quartus(nameofexecutable) == "quartus_sh") || ($::quartus(nameofexecutable) == "qpro_sh")} {
	main
} else {
	post_message -type error "The Arria 10 PR compile flow script can only be run from the Quartus GUI or quartus_sh."
}
