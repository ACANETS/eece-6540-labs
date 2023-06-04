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


# This SDC is used to constrain a design that includes the Partial
# Reconfiguration IP Core.
#
# Note that when the IP is configured to use the JTAG host, a modification to
# the standard jtag.sdc is required to disable the set_clock_groups exception
# for the altera_reserved_tck JTAG clock

# For cases where automatic detection of the Partial Reconfiguration IP Core
# is not possible, a setup script in the project directory named pr_ip_setup.tcl
# can be used. This script should look like:
#
# variable pr_ip_inst "instance name of Partial Reconfiguration IP Core"
# variable pr_ip_user_clock "Name of user clock driving the Partial Reconfiguration IP Core""
# variable pr_ip_jtag_exclude_clocks "List of clocks to be exclusive to the JTAG clock"

namespace eval pr_ip_timing {
    # Configuration
    ###############################
    # Instance name of the PR IP
    variable pr_ip_inst ""
    # Name of all clocks to exclude from the JTAG clock. By default this is all clocks currently defined.
    variable pr_ip_jtag_exclude_clocks ""
    # Name of the PR IP supplied user clock
    variable pr_ip_user_clock ""
    # Enable multicycle time on the PR atom. This can ease
    # P2C/C2P timing
    variable pr_ip_enable_multicycle 1
    ###############################

    # Shorthand to determine if we are in qfit
    variable in_qfit [string equal quartus_fit $::TimeQuestInfo(nameofexecutable)]
    # Shorthand variable to the PR atom
    variable pr_atom ""
    
# PR atom timing:
#
# Clk
#   ------    ------    -----     -----
#   |    |    |    |    |    |    |
#        ------    ------    ------
# Neg Clk
#        ------    ------    ------
#   |    |    |    |    |    |    |
#   ------    ------    -----     -----
# enable_dclk_reg2      
#                  ---------------------
#                  |                   |
#   ----------------                   -----
# PR Atom CLK (Clk & enable_dclk_reg2)
#                       ------    ------
#                       |    |    |    |
#   ---------------------    -----     -----

# PR clock mux timing:
#
# Clk
#   ------    ------    -----     -----
#   |    |    |    |    |    |    |
#        ------    ------    ------
# Neg Clk
#        ------    ------    ------
#   |    |    |    |    |    |    |
#   ------    ------    -----     -----
# ena_r2
#                  ---------------------
#                  |                   |
#   ----------------                   -----
# Clock Mux output
#                       ------    ------
#                       |    |    |    |
#   ---------------------    -----     -----

    proc pr_msg {type msg} {
        variable in_qfit
        
        if {$in_qfit == 0} {
            post_message -type $type "alt_pr.sdc: $msg"
        }
    }
    
    proc create_pr_ip_clocks {} {
        variable pr_ip_inst
        variable pr_ip_jtag_exclude_clocks
        variable pr_ip_user_clock
        
        # First determine if internal host is enabled. Do this my looking for the ena_r2 register.
        if {[get_collection_size [get_registers -nowarn ${pr_ip_inst}|pr_jtag_clk_mux|ena_r2[1]]] > 0} {
            create_pr_ip_clocks_jtag_mode
        } else {
            create_pr_ip_clocks_non_jtag_mode
        }
    }
        
    proc create_pr_ip_clocks_jtag_mode {} {
        variable pr_ip_inst
        variable pr_ip_jtag_exclude_clocks
        variable pr_ip_user_clock
        
        pr_msg "info" "Constraining Partial Reconfiguration IP Core $pr_ip_inst in JTAG host mode"
        
        set dclk_reg_name [check_register_exists "*|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|enable_dclk_reg2"]
        if {$dclk_reg_name == ""} {return 0}
        pr_msg "info" "Constraining Partial Reconfiguration IP Core gated clock $dclk_reg_name"

        set pr_ip_jtag_clk_mux_reg [check_register_exists "${pr_ip_inst}|pr_jtag_clk_mux|ena_r2[1]"]
        if {$pr_ip_jtag_clk_mux_reg == ""} {return 0}
        pr_msg "info" "Constraining Partial Reconfiguration IP Core JTAG clock mux $pr_ip_jtag_clk_mux_reg"
        set pr_ip_jtag_clock [get_register_clock $pr_ip_jtag_clk_mux_reg]
        if {$pr_ip_jtag_clock == ""} {
            pr_msg "critical_warning" "JTAG clock altera_reserved_tck has not been defined. Ensure that the JTAG clock has been defined prior to constraining the Partial Reconfiguration IP Core"
            return 0
        }
        pr_msg "info" "Using JTAG clock name $pr_ip_jtag_clock for the Partial Reconfiguration IP Core"
        
        set pr_ip_user_clk_mux_reg [check_register_exists "${pr_ip_inst}|pr_jtag_clk_mux|ena_r2[0]"]
        if {$pr_ip_user_clk_mux_reg == ""} {return 0}
        set pr_ip_user_clock [get_register_clock $pr_ip_user_clk_mux_reg]
        if {$pr_ip_user_clock == ""} {
            pr_msg "critical_warning" "User supplied clock driving the Partial Reconfiguration IP Core has not been defined. Ensure that the clock has been defined prior to constraining the Partial Reconfiguration IP Core"
            return 0
        }
        pr_msg "info" "Constraining Partial Reconfiguration IP Core User clock mux $pr_ip_user_clk_mux_reg"
        pr_msg "info" "Using user clock name $pr_ip_user_clock for the Partial Reconfiguration IP Core"

        # Make the JTAG clock exclusive to only the named clocks
        if {$pr_ip_jtag_exclude_clocks == ""} {
            set pr_ip_jtag_exclude_clocks [remove_from_collection [all_clocks] [get_clocks -nowarn $pr_ip_jtag_clock]]
        }
        set_clock_groups -asynchronous -group $pr_ip_jtag_clock -group $pr_ip_jtag_exclude_clocks
    
        #######################################################################
        # Create the pr_jtag_clk_mux generated clocks
        #######################################################################
        # JTAG Clock
        create_generated_clock -name pr_clk_pr_clk_mux_jtag_clk -source [get_clock_info -targets [get_clocks $pr_ip_jtag_clock]] -divide_by 1 -invert $pr_ip_jtag_clk_mux_reg
        set_clock_groups -asynchronous -group {pr_clk_pr_clk_mux_jtag_clk} -group $pr_ip_jtag_exclude_clocks
    
        # User Clock
        create_generated_clock -name pr_clk_pr_clk_mux_user_clk -source [get_clock_info -targets [get_clocks $pr_ip_user_clock]] -divide_by 1 -invert $pr_ip_user_clk_mux_reg
        set_clock_groups -asynchronous -group {pr_clk_pr_clk_mux_user_clk} -group $pr_ip_jtag_clock
        set_clock_groups -asynchronous -group {pr_clk_pr_clk_mux_user_clk} -group {pr_clk_pr_clk_mux_jtag_clk}
    
        #######################################################################
        #######################################################################
        # Create the enable_dclk_reg2 generated clocks
        #######################################################################
        # JTAG Clock
        create_generated_clock -name pr_clk_enable_dclk_reg2_jtag_clk -source [get_clock_info -targets [get_clocks $pr_ip_jtag_clock]] -divide_by 1 -invert $dclk_reg_name
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_reg2_jtag_clk} -group $pr_ip_jtag_exclude_clocks
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_reg2_jtag_clk} -group {pr_clk_pr_clk_mux_user_clk}
        
        # pr_clk_pr_clk_mux_jtag_clk Clock
        create_generated_clock -add -name pr_clk_enable_dclk_reg2_jtag_mux_clk -source [get_clock_info -targets [get_clocks pr_clk_pr_clk_mux_jtag_clk]] -divide_by 1 -invert $dclk_reg_name
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_reg2_jtag_mux_clk} -group $pr_ip_jtag_exclude_clocks
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_reg2_jtag_mux_clk} -group {pr_clk_pr_clk_mux_user_clk}

        # User Clock
        create_generated_clock -add -name pr_clk_enable_dclk_reg2_user_clk -source [get_clock_info -targets [get_clocks $pr_ip_user_clock]] -divide_by 1 -invert $dclk_reg_name
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_reg2_user_clk} -group $pr_ip_jtag_clock
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_reg2_user_clk} -group {pr_clk_pr_clk_mux_jtag_clk}
                
        # pr_clk_pr_clk_mux_user_clk Clock
        create_generated_clock -add -name pr_clk_enable_dclk_reg2_user_mux_clk -source [get_clock_info -targets [get_clocks pr_clk_pr_clk_mux_user_clk]] -divide_by 1 -invert $dclk_reg_name
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_reg2_user_mux_clk} -group $pr_ip_jtag_clock
        set_clock_groups -asynchronous -group {pr_clk_enable_dclk_reg2_user_mux_clk} -group {pr_clk_pr_clk_mux_jtag_clk}
        
        
        #######################################################################
        # Multicycles between generated clocks and clocks
        #######################################################################
        # The generated clock to the jtag clock transfers are 1.5 cycles. Achieve this using a multicycle of 2 since the
        # first 0.5 cycle is take my the clock inversion
        set_multicycle_path -to [get_clocks {pr_clk_pr_clk_mux_jtag_clk}] -from [get_clocks $pr_ip_jtag_clock] -setup 2
        set_multicycle_path -to [get_clocks {pr_clk_pr_clk_mux_jtag_clk}] -from [get_clocks $pr_ip_jtag_clock] -hold 1
        
        set_multicycle_path -from [get_clocks {pr_clk_pr_clk_mux_jtag_clk}] -to [get_clocks $pr_ip_jtag_clock] -setup 2
        set_multicycle_path -from [get_clocks {pr_clk_pr_clk_mux_jtag_clk}] -to [get_clocks $pr_ip_jtag_clock] -hold 1

        set_multicycle_path -to [get_clocks pr_clk_pr_clk_mux_user_clk] -from [get_clocks $pr_ip_user_clock] -setup 2
        set_multicycle_path -to [get_clocks pr_clk_pr_clk_mux_user_clk] -from [get_clocks $pr_ip_user_clock] -hold 1
        
        set_multicycle_path -from [get_clocks pr_clk_pr_clk_mux_user_clk] -to [get_clocks $pr_ip_user_clock] -setup 2
        set_multicycle_path -from [get_clocks pr_clk_pr_clk_mux_user_clk] -to [get_clocks $pr_ip_user_clock] -hold 1
    }
    
    proc create_pr_ip_clocks_non_jtag_mode {} {
        variable pr_ip_inst
        variable pr_ip_user_clock
        
        pr_msg "info" "Constraining Partial Reconfiguration IP Core $pr_ip_inst in non-JTAG host mode"

        set dclk_reg_name [check_register_exists "*|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|enable_dclk_reg2"]
        if {$dclk_reg_name == ""} {return 0}
        pr_msg "info" "Constraining Partial Reconfiguration IP Core gated clock $dclk_reg_name"

        set pr_ip_user_clock [get_register_clock $dclk_reg_name]
        if {$pr_ip_user_clock == ""} {return 0}
        pr_msg "info" "Using user clock name $pr_ip_user_clock for the Partial Reconfiguration IP Core"


        #######################################################################
        # Create the enable_dclk_reg2 generated clocks
        #######################################################################
        # User Clock
        create_generated_clock -add -name pr_clk_enable_dclk_reg2_user_clk -source [get_clock_info -targets [get_clocks $pr_ip_user_clock]] -divide_by 1 -invert $dclk_reg_name
    }
    
    proc create_pr_ip_multicycles {} {
        variable pr_ip_inst
        variable pr_ip_enable_multicycle
        
        #######################################################################
        # PR atom inputs/outputs are multicycled
        #######################################################################
        if {$pr_ip_enable_multicycle} {
            # Multicycle the output of the PR atom to core registers and then pr_request to the PR atom. Only the pr_data synchronous to the PR clock
            set_multicycle_path -from ${pr_ip_inst}|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg -to {*} -setup -start 2                                               
            set_multicycle_path -from ${pr_ip_inst}|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg -to {*} -hold -start 1
            set_multicycle_path -to ${pr_ip_inst}|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg -from ${pr_ip_inst}|alt_pr_cb_host|alt_pr_cb_controller_v2|pr_request_reg -setup -start 2                                               
            set_multicycle_path -to ${pr_ip_inst}|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg -from ${pr_ip_inst}|alt_pr_cb_host|alt_pr_cb_controller_v2|pr_request_reg -hold -start 1
        }
        
    }
    
    proc report_pr_timing {} {
        variable pr_ip_inst
        
        report_timing -from "${pr_ip_inst}|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg" -setup -npaths 200 -detail full_path -panel_name "Partial Reconfiguration IP Core ${pr_ip_inst}||From pr block (P2C)- setup" -multi_corner
        report_timing -to "${pr_ip_inst}|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg" -setup -npaths 200 -detail full_path -panel_name "Partial Reconfiguration IP Core ${pr_ip_inst}||To pr block (C2P) - setup" -multi_corner
        report_timing -from "${pr_ip_inst}|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg" -hold -npaths 200 -detail full_path -panel_name "Partial Reconfiguration IP Core ${pr_ip_inst}||From pr block (P2C)- hold" -multi_corner
        report_timing -to "${pr_ip_inst}|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg" -hold -npaths 200 -detail full_path -panel_name "Partial Reconfiguration IP Core ${pr_ip_inst}||To pr block (C2P) - hold" -multi_corner
    
    }

    proc find_pr_ip {} {
        variable pr_ip_inst

        # Look for the dclk_neg_reg and dclk_reg registers. Both exist in the 16.0 PR IP
        set dclk_reg_name [check_register_exists "*|alt_pr_bitstream_host|alt_pr_bitstream_controller_v2|enable_dclk_reg2"]
        if {$dclk_reg_name == ""} {
            pr_msg "critical_warning" "Unexpected Partial Reconfiguration IP Core configuration. Cannot constrain Partial Reconfiguration IP Core."
            return 0
        }
        
        # Get the instance name from the registers
        if {[regexp -- {^\s*(\S+?)\|alt_pr_bitstream_host\|alt_pr_bitstream_controller_v2\|enable_dclk_reg2} $dclk_reg_name foo pr_ip_inst1] == 0} {
            pr_msg "critical_warning" "Could not determine Partial Reconfiguration IP Core instance from register name $dclk_reg_name"
            return 0
        }
       
        set pr_ip_inst $pr_ip_inst1
        
        return 1
    }
    
    proc find_pr_atom {} {
        variable pr_atom

        # Set the PR atom variable
        set pr_atom [check_register_exists "*|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg"]
        
        
        # Look for the pr atom
        if {$pr_atom == ""} {
            pr_msg "warning" "Could not find Partial Reconfiguration control bloc atom *|alt_pr_cb_host|alt_pr_cb_controller_v2|alt_pr_cb_interface|m_prblock~cs_css/pr_clk_core.reg in the current design. Cannot constrain the Partial Reconfiguration IP Core."
            return 0
        } else {
            pr_msg "info" "Found Partial Reconfiguration atom in design $pr_atom"
            return 1
        }
    }

    proc check_register_exists {reg_name} {
        set reg [get_registers -nowarn $reg_name]
        if {[get_collection_size $reg] == 0} {
            pr_msg "warning" "Expected register $reg_name could not be found in the design."
            return ""
        } elseif {[get_collection_size $reg] > 1} {
            pr_msg "critical_warning" "Expected register $reg_name found more than once in the design, but only 1 instance was expected."
            return ""
        }

        set full_reg_name ""
        foreach_in_collection c $reg {set full_reg_name [get_node_info -name $c]}

        return $full_reg_name
    }
    
    proc traverse_fanin_up_to_clock {node_id depth} {
        if {$depth < 0} {
            pr_msg "critical_warning" "Cannot traverse fanin to find clock"
        }
        set fanin_edges [get_node_info -clock_edges $node_id]
        set number_of_fanin_edges [llength $fanin_edges]
        
        for {set i 0} {$i != $number_of_fanin_edges} {incr i} {
            set fanin_edge [lindex $fanin_edges $i]
            set fanin_id [get_edge_info -src $fanin_edge]
            set fanin_name [get_node_info -name $fanin_id]
            set clock_target_name [get_node_clock_list $fanin_name]
            if {$clock_target_name != ""} {
                return $clock_target_name
            } elseif {$depth == 0} {
                return ""
            } else {
                return [traverse_fanin_up_to_clock $fanin_id [expr {$depth - 1}]]
            }
        }
    }


    
    proc get_register_clock {reg_name} {

        set full_reg_name [check_register_exists $reg_name]
        if {$full_reg_name == ""} {return ""}
     
        set clock_name [traverse_fanin_up_to_clock "${reg_name}|clk" 10]
        if {$clock_name == ""} {
            pr_msg "critical_warning" "Could not determine clock for register $full_reg_name."
            return ""
        }
        
        if {[get_collection_size [get_clocks -nowarn $clock_name]] == 0} {
            pr_msg "critical_warning" "No clock named $clock_name has been defined. Ensure this clock is defined before constraining the Partial Reconfiguration IP Core"
            return ""
        }
        
        return $clock_name
    }

    proc constrain_pr_ip {} {
        
        set setup_script [file join [get_project_directory] pr_ip_setup.tcl]
        
        if {[find_pr_atom] == 0} {
            pr_msg "warning" "Could not constrain Partial Reconfiguration IP Core"
        } else {
        
            # Is there a setup script?
            if {[file exists $setup_script]} {
                pr_msg "info" "Sourcing Partial Reconfiguration IP Core configuration from $setup_script"
                source $setup_script
                if {[create_pr_ip_clocks] == 0} {
                    pr_msg "critical_warning" "Could not constrain Partial Reconfiguration IP Core"
                } else {
                    create_pr_ip_multicycles
                }
            # Autodetect the PR IP if not specified
            } else {
                if {[find_pr_ip] == 0} {
                    # The PR atom was detected, but the IP was not
                    pr_msg "critical_warning" "Could not find a legal Partial Reconfiguration IP Core instantiation in the design"
                } else {
                    if {[create_pr_ip_clocks] == 0} {
                        pr_msg "critical_warning" "Could not constrain Partial Reconfiguration IP Core"
                    } else {
                        create_pr_ip_multicycles
                    }
                }
            }
        }
    }

}
pr_ip_timing::constrain_pr_ip
