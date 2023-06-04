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


# CORE_PARAMETERS
set DATAPATH_OPTION 3
set PREAMBLE_PASSTHROUGH 0
set ENABLE_PFC 0
set PFC_PRIORITY_NUMBER 8
set ENABLE_SUPP_ADDR 1
set ENABLE_TIMESTAMPING 0
set INSERT_ST_ADAPTOR 0
set INSERT_XGMII_ADAPTOR 1
set USE_ASYNC_ADAPTOR 0
set ENABLE_UNIDIRECTIONAL 0
set ENABLE_1G10G_MAC 0

set old_mode [set_project_mode -get_mode_value always_show_entity_name] 
set_project_mode -always_show_entity_name on

# Function to constraint non-std_synchronizer path
proc alt_em10g32_constraint_net_delay {from_reg to_reg max_net_delay} {
    
    
    if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
        set_max_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] 100ns
        set_min_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -100ns
    } else {
       # Relax the fitter effort
        set_net_delay -from [get_pins -compatibility_mode ${from_reg}|q] -to [get_registers ${to_reg}] -max $max_net_delay
    
       
        set_max_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] 3.2ns
        set_min_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -100ns
    }
    
}

# Function to constraint std_synchronizer
proc alt_em10g32_constraint_std_sync {} {
    
    alt_em10g32_constraint_net_delay  *  *alt_em10g32:*|alt_em10g32_std_synchronizer:*|din_s1  2.7ns
    
}

# Function to constraint pointers
proc alt_em10g32_constraint_ptr {from_path from_reg to_path to_reg max_skew max_net_delay} {
    
    
    if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
        # Check for instances
        set inst [get_registers -nowarn *${from_path}|${from_reg}\[0\]]
        
        # Check number of instances
        set inst_num [llength [query_collection -report -all $inst]]
        if {$inst_num > 0} {
            # Uncomment line below for debug purpose
            #puts "${inst_num} ${from_path}|${from_reg} instance(s) found"
        } else {
            # Uncomment line below for debug purpose
            #puts "No ${from_path}|${from_reg} instance found"
        }
        
        # Constraint one instance at a time to avoid set_max_skew apply to all instances
        foreach_in_collection each_inst_tmp $inst {
            set each_inst [get_node_info -name $each_inst_tmp] 
				#regsub {\\} $each_inst_name {*} each_inst

            # Get the path to instance
            regexp "(.*${from_path})(.*|)(${from_reg})" $each_inst reg_path inst_path inst_name reg_name
            
            set_max_skew -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] $max_skew
            
            set_max_delay -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] 100ns
            set_min_delay -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] -100ns
        }
        
    } else {
    
        set inst [get_registers -nowarn *${from_path}|${from_reg}\[0\]]
        
        # Check number of instances
        set inst_num [llength [query_collection -report -all $inst]]
        if {$inst_num > 0} {
            # Uncomment line below for debug purpose
            #puts "${inst_num} ${from_path}|${from_reg} instance(s) found"
        } else {
            # Uncomment line below for debug purpose
            #puts "No ${from_path}|${from_reg} instance found"
        }
        
        # Constraint one instance at a time to avoid set_max_skew apply to all instances

        set TQ2 [get_global_assignment -name TIMEQUEST2]
        if { $TQ2 == "ON"} {
            foreach_in_collection each_inst_tmp $inst {
                set each_inst [get_node_info -name $each_inst_tmp] 
                #regsub {\\} $each_inst_name {*} each_inst
                # Get the path to instance
                regexp "(.*${from_path})(.*|)(${from_reg})" $each_inst reg_path inst_path inst_name reg_name
                
                set_max_skew -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] $max_skew
                
            }
        }
    
        set_net_delay -from [get_pins -compatibility_mode *${from_path}|${from_reg}[*]|q] -to [get_registers *${to_path}|${to_reg}*] -max $max_net_delay
    
        
        # Relax the fitter effort
        set_max_delay -from [get_registers *${from_path}|${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] 3.2ns
        set_min_delay -from [get_registers *${from_path}|${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] -100ns
    }
    
}

# Function to constraint clock crosser
proc alt_em10g32_constraint_clock_crosser {} {
    set module_name alt_em10g32_clock_crosser
    
    set from_reg1 in_data_toggle
    set to_reg1 altera_std_synchronizer_nocut:synchronizer_nocut_forward_sync|din_s1
    
    set from_reg2 in_data_buffer
    set to_reg2 out_data_buffer
    
    set from_reg3 out_data_toggle_flopped
    set to_reg3 altera_std_synchronizer_nocut:synchronizer_nocut_backward_sync|din_s1
    
    set max_skew 3ns
    
    set max_delay1 3ns
    set max_delay2 2.7ns
    set max_delay3 3ns
    
    
    if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
        # Check for instances
        set inst [get_registers -nowarn *${module_name}:*|${from_reg1}]
        
        # Check number of instances
        set inst_num [llength [query_collection -report -all $inst]]
        if {$inst_num > 0} {
            # Uncomment line below for debug purpose
            #puts "${inst_num} ${module_name} instance(s) found"
        } else {
            # Uncomment line below for debug purpose
            #puts "No ${module_name} instance found"
        }
        
        # Constraint one instance at a time to avoid set_max_skew apply to all instances
		foreach_in_collection each_inst_tmp $inst {
            set each_inst [get_node_info -name $each_inst_tmp] 
            #regsub {\\} $each_inst_name {*} each_inst
            # Get the path to instance
            regexp "(.*${module_name})(:.*|)(${from_reg1})" $each_inst reg_path inst_path inst_name reg_name
            
            # Check if unused data buffer get synthesized away
            set reg2_collection [get_registers -nowarn ${inst_path}${inst_name}${to_reg2}[*]]
            set reg2_num [llength [query_collection -report -all $reg2_collection]]

            if {$reg2_num > 0} {
                set_max_skew -from [get_registers "${inst_path}${inst_name}${from_reg1} ${inst_path}${inst_name}${from_reg2}[*]"] -to [get_registers "${inst_path}${inst_name}${to_reg1} ${inst_path}${inst_name}${to_reg2}[*]"] $max_skew
                
                set_max_delay -from [get_registers ${inst_path}${inst_name}${from_reg2}[*]] -to [get_registers ${inst_path}${inst_name}${to_reg2}[*]] 100ns
                set_min_delay -from [get_registers ${inst_path}${inst_name}${from_reg2}[*]] -to [get_registers ${inst_path}${inst_name}${to_reg2}[*]] -100ns
            }
            
            set_max_delay -from [get_registers ${inst_path}${inst_name}${from_reg1}] -to [get_registers ${inst_path}${inst_name}${to_reg1}] 100ns
            set_min_delay -from [get_registers ${inst_path}${inst_name}${from_reg1}] -to [get_registers ${inst_path}${inst_name}${to_reg1}] -100ns
            
            set_max_delay -from [get_registers ${inst_path}${inst_name}${from_reg3}] -to [get_registers ${inst_path}${inst_name}${to_reg3}] 100ns
            set_min_delay -from [get_registers ${inst_path}${inst_name}${from_reg3}] -to [get_registers ${inst_path}${inst_name}${to_reg3}] -100ns
        }
        
    } else {
    
			set inst [get_registers -nowarn *${module_name}:*|${from_reg1}]
        
			# Check number of instances
			set inst_num [llength [query_collection -report -all $inst]]
			if {$inst_num > 0} {
            # Uncomment line below for debug purpose
            #puts "${inst_num} ${module_name} instance(s) found"
			} else {
            # Uncomment line below for debug purpose
            #puts "No ${module_name} instance found"
			}
        
			
            
            set TQ2 [get_global_assignment -name TIMEQUEST2]
            if { $TQ2 == "ON"} {
                # Constraint one instance at a time to avoid set_max_skew apply to all instances
                foreach_in_collection each_inst_tmp $inst {
                    set each_inst [get_node_info -name $each_inst_tmp] 
                    #regsub {\\} $each_inst_name {*} each_inst
                    # Get the path to instance
                    regexp "(.*${module_name})(:.*|)(${from_reg1})" $each_inst reg_path inst_path inst_name reg_name
            
                    # Check if unused data buffer get synthesized away
                    set reg2_collection [get_registers -nowarn ${inst_path}${inst_name}${to_reg2}[*]]
                    set reg2_num [llength [query_collection -report -all $reg2_collection]]
                    if {$reg2_num > 0} {
                        set_max_skew -from [get_registers "${inst_path}${inst_name}${from_reg1} ${inst_path}${inst_name}${from_reg2}[*]"] -to [get_registers "${inst_path}${inst_name}${to_reg1} ${inst_path}${inst_name}${to_reg2}[*]"] $max_skew
                
                    }
                }	
            
            } else {

            }
            
	 
        set_net_delay -from [get_pins -compatibility_mode *${module_name}:*|${from_reg1}|q]    -to [get_registers *${module_name}:*|${to_reg1}] -max $max_delay1
        set_net_delay -from [get_pins -compatibility_mode *${module_name}:*|${from_reg2}[*]|q] -to [get_registers *${module_name}:*|${to_reg2}[*]] -max $max_delay2
        set_net_delay -from [get_pins -compatibility_mode *${module_name}:*|${from_reg3}|q]    -to [get_registers *${module_name}:*|${to_reg3}] -max $max_delay3
    
        
        # Relax the fitter effort
        set_max_delay -from [get_registers *${module_name}:*|${from_reg1}] -to [get_registers *${module_name}:*|${to_reg1}] 3.2ns
        set_min_delay -from [get_registers *${module_name}:*|${from_reg1}] -to [get_registers *${module_name}:*|${to_reg1}] -100ns
        
        set_max_delay -from [get_registers *${module_name}:*|${from_reg2}[*]] -to [get_registers *${module_name}:*|${to_reg2}[*]] 3.2ns
        set_min_delay -from [get_registers *${module_name}:*|${from_reg2}[*]] -to [get_registers *${module_name}:*|${to_reg2}[*]] -100ns
        
        set_max_delay -from [get_registers *${module_name}:*|${from_reg3}] -to [get_registers *${module_name}:*|${to_reg3}] 3.2ns
        set_min_delay -from [get_registers *${module_name}:*|${from_reg3}] -to [get_registers *${module_name}:*|${to_reg3}] -100ns
    }
    
}

# Standard Synchronizer
alt_em10g32_constraint_std_sync

# Clock Crosser
alt_em10g32_constraint_clock_crosser

# always
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|pri_macaddr_bit31to0[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|pri_macaddr_bit31to0[*]}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|pri_macaddr_bit47to32[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|pri_macaddr_bit47to32[*]}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]

# Reset 
# Async reset
set_false_path -to [get_pins -compatibility_mode -nocase *|alt_em10g32_clk_rst:clk_rst_inst*|altera_reset_synchronizer_int_chain*|clrn]

# Sync reset
set_false_path -to [get_registers *|alt_em10g32_clk_rst:clk_rst_inst*|altera_reset_synchronizer_int_chain[0]]

# false path from speed_sel during multi speed mode
if {$ENABLE_1G10G_MAC != 0 } {
    
	set_false_path -from [get_registers {*alt_em10g32unit:alt_em10g32unit_inst|alt_em10g32_dcfifo_synchronizer_bundle:speed_sel_3bits_sync_tx|alt_em10g32_std_synchronizer:sync[*].u|altera_std_synchronizer_nocut:std_sync_no_cut|dreg[0]}] -to *
	if {$ENABLE_1G10G_MAC != 5 } {
		set_false_path -from [get_registers {*alt_em10g32unit:alt_em10g32unit_inst|alt_em10g32_dcfifo_synchronizer_bundle:speed_sel_3bits_sync_rx|alt_em10g32_std_synchronizer:sync[*].u|altera_std_synchronizer_nocut:std_sync_no_cut|dreg[0]}] -to *
    }
}

# DC FIFO
if {[expr ($INSERT_ST_ADAPTOR == 1)] || ([expr ($INSERT_XGMII_ADAPTOR == 1)] && [expr ($USE_ASYNC_ADAPTOR == 1)])} {
    alt_em10g32_constraint_ptr  alt_em10g32_avalon_dc_fifo:*  in_wr_ptr_gray  alt_em10g32_avalon_dc_fifo:*|alt_em10g32_dcfifo_synchronizer_bundle:write_crosser|*  din_s1  3ns  2.7ns
    alt_em10g32_constraint_ptr  alt_em10g32_avalon_dc_fifo:*  out_rd_ptr_gray  alt_em10g32_avalon_dc_fifo:*|alt_em10g32_dcfifo_synchronizer_bundle:read_crosser|*  din_s1  3ns  2.7ns
    
    if {[expr ($INSERT_XGMII_ADAPTOR == 1)] && [expr ($USE_ASYNC_ADAPTOR == 1)] && [expr ($ENABLE_TIMESTAMPING == 1)]} {
        alt_em10g32_constraint_ptr  alt_em10g32_avalon_dc_fifo_lat_calc:*  wr_ptr_sample  alt_em10g32_avalon_dc_fifo_lat_calc:*|alt_em10g32_dcfifo_synchronizer_bundle:wr_crosser|*  din_s1  3ns  2.7ns
        alt_em10g32_constraint_ptr  alt_em10g32_avalon_dc_fifo_lat_calc:*  rd_ptr_sample  alt_em10g32_avalon_dc_fifo_lat_calc:*|alt_em10g32_dcfifo_synchronizer_bundle:rd_crosser|*  din_s1  3ns  2.7ns
        
        set_multicycle_path -from [get_registers {*alt_em10g32*alt_em10g_32_64_xgmii_conversion*alt_em10g_dcfifo_32_to_64_xgmii_conversion:tx_dcfifo_xgmii_conversion*transfer_valid_slow[0]}] -to [get_registers {*alt_em10g32*alt_em10g_32_64_xgmii_conversion*alt_em10g_dcfifo_32_to_64_xgmii_conversion:tx_dcfifo_xgmii_conversion*transfer_valid_fast[0]}] -setup -end 2
        set_multicycle_path -from [get_registers {*alt_em10g32*alt_em10g_32_64_xgmii_conversion*alt_em10g_dcfifo_32_to_64_xgmii_conversion:tx_dcfifo_xgmii_conversion*transfer_valid_slow[0]}] -to [get_registers {*alt_em10g32*alt_em10g_32_64_xgmii_conversion*alt_em10g_dcfifo_32_to_64_xgmii_conversion:tx_dcfifo_xgmii_conversion*transfer_valid_fast[0]}] -hold -end 1
        
        set_multicycle_path -from [get_registers {*alt_em10g32*alt_em10g_32_64_xgmii_conversion*alt_em10g_dcfifo_32_to_64_xgmii_conversion:tx_dcfifo_xgmii_conversion*xgmii_tx_path_latency_slow[*]}] -to [get_registers {*alt_em10g32*alt_em10g_32_64_xgmii_conversion*alt_em10g_dcfifo_32_to_64_xgmii_conversion:tx_dcfifo_xgmii_conversion*xgmii_tx_path_latency_fast[*]}] -setup -end 2
        set_multicycle_path -from [get_registers {*alt_em10g32*alt_em10g_32_64_xgmii_conversion*alt_em10g_dcfifo_32_to_64_xgmii_conversion:tx_dcfifo_xgmii_conversion*xgmii_tx_path_latency_slow[*]}] -to [get_registers {*alt_em10g32*alt_em10g_32_64_xgmii_conversion*alt_em10g_dcfifo_32_to_64_xgmii_conversion:tx_dcfifo_xgmii_conversion*xgmii_tx_path_latency_fast[*]}] -hold -end 1
    }
}


#enable tx
if {[expr ($DATAPATH_OPTION == 1)] || [expr ($DATAPATH_OPTION == 3)]} {


set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pad_insrt_en}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_crc_insrt_en}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_sa_override_en}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_max_datafrmlen[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|txvlandet_dis}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pipg10g_dic[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pipg1g_fixed[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pausefrm_pqt[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pausefrm_xoff_hqt[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pausefrm_en}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pausefrm_policy[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]

    # Avalon-ST Adaptor
    if {[expr ($INSERT_ST_ADAPTOR == 1)]} {
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_adptdcff_rdwtrmrk_dis}] -to [get_registers {*alt_em10g32*altera_eth_avalon_st_adapter:st_adpt.avalon_st_adpt_inst|*}]
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_adptdcff_rdwtrmrk[*]}] -to [get_registers {*alt_em10g32*altera_eth_avalon_st_adapter:st_adpt.avalon_st_adpt_inst|*}]
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_adptdcff_vldpkt_minwt[*]}] -to [get_registers {*alt_em10g32*altera_eth_avalon_st_adapter:st_adpt.avalon_st_adpt_inst|*}]
    }
    
    #enable tx & preamble 
    if {[expr ($PREAMBLE_PASSTHROUGH == 1)]} {
    set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_preamb_passthru_en}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
    }
    
    # Unidirectional constraint
    if {[expr ($ENABLE_UNIDIRECTIONAL == 1)]} {
    set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_unidirectional_en}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
    set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_unidirectional_remote_fault_dis}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
	set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_unidirectional_force_remote_fault}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]

	}

    if {[expr ($ENABLE_PFC == 1)]} {
    
        if {[expr ($PFC_PRIORITY_NUMBER >= 2)]} {
        #enable tx + enable pfc + pfc num >0
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pfcfrm_en0}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pfcfrm_pqt0[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_xoff_hqt0[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        #enable tx + enable pfc + pfc num >1
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pfcfrm_en1}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pfcfrm_pqt1[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_xoff_hqt1[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        }
        
        if {[expr ($PFC_PRIORITY_NUMBER >= 3)]} {
        #enable tx + enable pfc + pfc num >2
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pfcfrm_en2}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pfcfrm_pqt2[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_xoff_hqt2[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}] 
        }
        
        if {[expr ($PFC_PRIORITY_NUMBER >= 4)]} {
        #enable tx + enable pfc + pfc num >3
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pfcfrm_en3}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pfcfrm_pqt3[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_xoff_hqt3[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]       
        }
 
        if {[expr ($PFC_PRIORITY_NUMBER >= 5)]} {
        #enable tx + enable pfc + pfc num >4
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pfcfrm_en4}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pfcfrm_pqt4[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_xoff_hqt4[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        }   

        if {[expr ($PFC_PRIORITY_NUMBER >= 6)]} {
        #enable tx + enable pfc + pfc num >5
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pfcfrm_en5}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pfcfrm_pqt5[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_xoff_hqt5[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        }   

        if {[expr ($PFC_PRIORITY_NUMBER >= 7)]} {
        #enable tx + enable pfc + pfc num >6
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pfcfrm_en6}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pfcfrm_pqt6[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_xoff_hqt6[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        }
        
        if {[expr ($PFC_PRIORITY_NUMBER >= 8)]} {
        #enable tx + enable pfc + pfc num >7
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pfcfrm_en7}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_pfcfrm_pqt7[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|tx_xoff_hqt7[*]}] -to [get_registers {*alt_em10g32_tx_top:tx_path.tx_top_inst|*}]
        }
    
    }

}



if {[expr ($DATAPATH_OPTION == 2)] || [expr ($DATAPATH_OPTION == 3)]} {
#enable rx
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_crcpad_rem[*]}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_allucast_en}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_allmcast_en}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_fwd_ctlfrm}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_fwd_pausefrm}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_ignore_pausefrm}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_max_datafrmlen[*]}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rxvlandet_dis}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]

    if {[expr ($PREAMBLE_PASSTHROUGH == 1)]} {
    #enable rx and preamble pass through
    set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_preamb_passthru_en}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
    set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_preambctl_fwd}] -to [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_clock_crosser:clock_crosser_rx_clk_pulse_rx_pkt_ovrflw_errcnt|*}]
    }
 
    if {[expr ($ENABLE_SUPP_ADDR == 1)]} {
    #enable rx and supplement address
    set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_suppaddr_en0}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
    set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_suppaddr_en1}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
    set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_suppaddr_en2}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
    set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_suppaddr_en3}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
    set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_supp_macaddr_bit31to0_0[*]}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
    set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_supp_macaddr_bit47to32_0[*]}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
    set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_supp_macaddr_bit31to0_1[*]}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
    set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_supp_macaddr_bit47to32_1[*]}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
    set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_supp_macaddr_bit31to0_2[*]}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
    set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_supp_macaddr_bit47to32_2[*]}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
    set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_supp_macaddr_bit31to0_3[*]}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
    set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_supp_macaddr_bit47to32_3[*]}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
    
    } 

    if {[expr ($ENABLE_PFC == 1)]} {
    #enable rx + pfc
    set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_pfc_fwd}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]   
    

        if {[expr ($PFC_PRIORITY_NUMBER >= 2)]} {
        #enable rx + pfc + pfc num >0
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_pfc_ignore_pausefrm_0}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]

        #enable rx + pfc + pfc num >1
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_pfc_ignore_pausefrm_1}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
        }
    
        if {[expr ($PFC_PRIORITY_NUMBER >= 3)]} {
        #enable rx + pfc + pfc num >2
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_pfc_ignore_pausefrm_2}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
        
        }
        
        if {[expr ($PFC_PRIORITY_NUMBER >= 4)]} {
        #enable rx + pfc + pfc num >3
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_pfc_ignore_pausefrm_3}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
        }
        
        if {[expr ($PFC_PRIORITY_NUMBER >= 5)]} {
        #enable rx + pfc + pfc num >4
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_pfc_ignore_pausefrm_4}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
        
        }
        
        if {[expr ($PFC_PRIORITY_NUMBER >= 6)]} {
        #enable rx + pfc + pfc num >5
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_pfc_ignore_pausefrm_5}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
        }
        
        if {[expr ($PFC_PRIORITY_NUMBER >= 7)]} {
        #enable rx + pfc + pfc num >6
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_pfc_ignore_pausefrm_6}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
        }
        
        if {[expr ($PFC_PRIORITY_NUMBER >= 8)]} {
        #enable rx + pfc + pfc num >7
        set_false_path -from [get_registers {*alt_em10g32_creg_top:creg_top_inst|alt_em10g32_creg_map:alt_em10g32_creg_map_inst|rx_pfc_ignore_pausefrm_7}] -to [get_registers {*alt_em10g32_rx_top:rx_path.rx_top_inst|*}]
        }
    
    }

}

set_project_mode -always_show_entity_name $old_mode
