if {$::quartus(nameofexecutable) == "quartus_fit"} {
    set_max_delay -from {*inst_blue_ccip_interface_reg*} -to {*inst_green_ccip_interface_reg*} 1.5
    set_max_delay -from {*inst_green_ccip_interface_reg*} -to {*inst_blue_ccip_interface_reg*} 1.5
}
