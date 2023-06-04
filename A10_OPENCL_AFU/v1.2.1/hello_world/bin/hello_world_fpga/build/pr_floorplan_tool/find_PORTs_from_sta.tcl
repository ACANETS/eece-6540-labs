
# Required packages
package require ::quartus::project
package require ::quartus::report
package require ::quartus::flow

post_message "Finding the X,Y coordinates of the SR-PR *~IPORT and *~OPORT signals for use in automated HPR floorplanning."

set project_name [lindex $quartus(args) 0]
set revision_name [lindex $quartus(args) 1]

post_message "Project name: $project_name"
post_message "Revision name: $revision_name"

load_package design
project_open -force $project_name -revision $revision_name
create_timing_netlist -model slow
#read_sdc
#update_timing_netlist

set mycollection [get_cells "fpga_top|inst_green_bs|*~?PORT"]
set port_filename [lindex $quartus(args) 2]
set port_file [open $port_filename w+]
post_message "PORT information will be written to $port_filename"
foreach_in_collection cell $mycollection {
    #puts [get_cell_info -location $cell]
    puts $port_file [get_cell_info -location $cell]
}
close $port_file

project_close
