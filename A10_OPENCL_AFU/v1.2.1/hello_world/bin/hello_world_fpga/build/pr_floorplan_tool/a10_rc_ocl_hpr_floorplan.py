
from logiclock_lib import *
import re
import sys
import subprocess
import os

run_findports_tcl_script=False
debug=False

#
#
#  This script should generate the floorplan for HPR regions used during the import OpenCL flow for 1.2.1.
#
#

if __name__ == '__main__':
    #need to find the X/Y locations of all of the IPORT and OPORT nodes
    #use find_PORTs_from_sta.tcl to create the X,Y list from quartus_sta
    #parameters required: 
    # 1 - path of the compiled project; 
    # 2 - project name; 
    # 3 - revision name; 
    # 4 - destination path;
    # 5 - name of the generated qsf file containing floorplan constraints
    if len(sys.argv) < 6:
        print 'You must provide the following arguments:'
        print '1. path to the compiled project or ports_list.txt.'
        print '2. project name (ex. dcp.qpf).'
        print '3. project revision (ex. dcp)'
        print '4. destination path to write the qsf file.'
        print '5. name of the output qsf file.'
        if run_findports_tcl_script:
            print '6. location of the tcl script used by quartus_sta -t.'
        print 'Please try again with the appropriate arguments!'
        sys.exit(1) #abort because of the error
    compiled_project_path = sys.argv[1]
    print "The compiled-project-path is " + compiled_project_path
    project_name = sys.argv[2]
    print "The project-name is " + compiled_project_path + project_name
    project_path_and_name = compiled_project_path + project_name
    print "The full project path and name is " + project_path_and_name
    revision_name = sys.argv[3]
    print "The revision-name is " + revision_name
    destination_path = sys.argv[4]
    print "The destination path is " + destination_path
    hpr_outfilename = sys.argv[5]
    print "The output file containing the floorplan constraints will be " + hpr_outfilename
    destination_hpr_outfilename_full = destination_path + hpr_outfilename
    print "The full path and name of the output qsf file is " + destination_hpr_outfilename_full
    if run_findports_tcl_script:
        findports_script = sys.argv[6]
        print "The tcl script used with quartus_sta is " + findports_script
    #create a file for the IPORT and OPORT data
    ports_list_filename = destination_path + "ports_list.txt"
    if run_findports_tcl_script:
        print "Running the findports tcl script to create the X-Y coordinate list from quartus_sta."
        #create the command to run the tcl script that uses quartus_sta to find the X,Y data.
        tcl_cmd = "quartus_sta -t " + findports_script + " " + project_path_and_name + " " + revision_name + " " + ports_list_filename
        print "The full quartus_sta command to generate ports_list.txt is: " + tcl_cmd
        os.system(tcl_cmd)
    else:
        print "Using the existing ports_list.txt - from the BBS compilation or manually generated."
    #At this point we have the wire-LUT locations for all of the IPORT and OPORTs between static region and PR region.
    #Now we need to parse the post-list ports_list_filename to create a non-overlapping table of X/Y coordinates; 
    #We don't care which node lands on which X/Y coordinate and we can ignore duplicate X/Y nodes.
    ports_list_file = open(ports_list_filename,"r")
    line_cnt = 0
    port_xy_list = []
    for line in ports_list_file:
        #find the X and Y values from 'line'
        if debug:
            print "line is " + line
        splitdata = line.split("_")
        if debug:
            print "splitdata line is "
            for col in splitdata:
                print col
        xval = splitdata[1][1:]
        yval = splitdata[2][1:]
        xy_coord = xval + "," + yval
        if debug:
            print "xval is " + xval + " yval is " + yval + " xy_coord is " + xy_coord
        #check the existing list to see if this xy-coordinate already exists; if it does, move on; 
        #if it is new, append it.
        if xy_coord not in port_xy_list:
            if debug:
                print "Adding a new coordinate of " + xy_coord + " to the list of xy-coordinates."
            port_xy_list.append(xy_coord)
        else:
            if debug:
                print xy_coord + " already exists in the list, not adding a duplicate."
        line_cnt = line_cnt + 1

    #sort the list (necessary?)
    port_xy_list.sort()
    if debug:
        #display the sorted list
        print "The sorted list of x,y coordinates is:"
        for xy in port_xy_list:
            print xy

    print "Number of X/Y coordinates in the list: " + str(len(port_xy_list))

    #Now we need to define some exclusion regions for the bsp_interface partition.
    #The main general bsp_interface partition region block is a mostly clean rectangle defined by (X17_Y55 to X43_Y177).
    # The way the logiclock_lib.py script works, however, is to define rectangles and enable a flag to include or exclude
    # a given rectangle.
    # Init a logiclock class object instance for the pr-region bsp_interface
    pr_bsp = logiclock_solver(partitionname="bsp_interface",name="fpga_top|inst_green_bs|bsp_interface_inst")
    # Start a list of [x1,y1,x2,y2] coordinates to exclude from bsp_interface partition.
    bsp_excl_regions = [];
    # Exclude a region for the PCIe / CCIP / FME near the PCIe pins - this is essentially a tall and skinny rectangle on 
    # the left side of the chip.
    bsp_excl_regions.append([0,0,16,223]);
    # Exclude a region for jtag / signaltap (bottom center)
    bsp_excl_regions.append([134,0,150,8]);
    # Exclude a region for PR logic (bottom center)
    bsp_excl_regions.append([102,0,111,2]);
    # Exclude regions for the freeze-wrapper/kernel-wrapper - X17 Y0 X224 Y54;X44 Y55 X224 Y177;X17 Y178 X224 Y224
    bsp_excl_regions.append([17,0,224,54]);
    bsp_excl_regions.append([44,55,224,177]);
    bsp_excl_regions.append([17,178,224,224]);
    bsp_excl_regions.append([0,224,16,224]);
    bsp_excl_regions.append([18,60,18,60]);
    # Exclude regions around the used EMIF IO column space for DDR Interface logic
    bsp_excl_regions.append([143,32,148,48  ]);
    bsp_excl_regions.append([143,60,148,72  ]);
    bsp_excl_regions.append([143,80,148,105 ]);
    bsp_excl_regions.append([143,114,148,130]);
    bsp_excl_regions.append([143,141,148,153]);
    bsp_excl_regions.append([143,161,148,186]);
    #now add exclusions for the wirelut IPORT/OPORTs based on the static-PR interface.
    cnt=0
    for xy in port_xy_list:
        cnt=cnt+1
        x = int(xy.split(",")[0])
        y = int(xy.split(",")[1])
        bsp_excl_regions.append([x,y,x,y]);
    #using all of the entries in the exclusion list (with respect to bsp_interface), add the regions to the BBS region (name doesn't really matter)
    for region in bsp_excl_regions:
        (x0, y0, x1, y1) = region;
        pr_bsp.add_region(rect_region(x0,y0,x1,y1,name="BBS",logiclocked=False))

    # Add placement regions for DDR AVMM bridges, pipelines, clock-crossings- enable these as logic-locked regions and as part of the bsp_interface partition
    pr_bsp.add_region(rect_region(88,63,96,73,name="fpga_top|inst_green_bs|bsp_interface_inst|ccip_std_afu|bsp_logic_inst|board_inst|ddr_board|ddr4a_pipe_0",logiclocked=True,res_place=True,core_only=True))
    pr_bsp.add_region(rect_region(88,145,96,155,name="fpga_top|inst_green_bs|bsp_interface_inst|ccip_std_afu|bsp_logic_inst|board_inst|ddr_board|ddr4b_pipe_0",logiclocked=True,res_place=True,core_only=True))
    pr_bsp.add_region(rect_region(129,53,133,56,name="fpga_top|inst_green_bs|bsp_interface_inst|ddr4a_avmm_bridge",logiclocked=True,res_place=True,core_only=True))
    pr_bsp.add_region(rect_region(129,57,130,57,name="fpga_top|inst_green_bs|bsp_interface_inst|ddr4a_avmm_bridge",logiclocked=True,res_place=True,core_only=True))
    pr_bsp.add_region(rect_region(132,57,133,57,name="fpga_top|inst_green_bs|bsp_interface_inst|ddr4a_avmm_bridge",logiclocked=True,res_place=True,core_only=True))
    pr_bsp.add_region(rect_region(129,79,133,83,name="fpga_top|inst_green_bs|bsp_interface_inst|ddr4a_avmm_bridge",logiclocked=True,res_place=True,core_only=True))
    pr_bsp.add_region(rect_region(157,53,161,57,name="fpga_top|inst_green_bs|bsp_interface_inst|ddr4a_avmm_bridge",logiclocked=True,res_place=True,core_only=True))
    pr_bsp.add_region(rect_region(157,79,161,83,name="fpga_top|inst_green_bs|bsp_interface_inst|ddr4a_avmm_bridge",logiclocked=True,res_place=True,core_only=True))
    pr_bsp.add_region(rect_region(129,135,133,139,name="fpga_top|inst_green_bs|bsp_interface_inst|ddr4b_avmm_bridge",logiclocked=True,res_place=True,core_only=True))
    pr_bsp.add_region(rect_region(129,161,133,165,name="fpga_top|inst_green_bs|bsp_interface_inst|ddr4b_avmm_bridge",logiclocked=True,res_place=True,core_only=True))
    pr_bsp.add_region(rect_region(157,135,161,139,name="fpga_top|inst_green_bs|bsp_interface_inst|ddr4b_avmm_bridge",logiclocked=True,res_place=True,core_only=True))
    pr_bsp.add_region(rect_region(157,161,161,165,name="fpga_top|inst_green_bs|bsp_interface_inst|ddr4b_avmm_bridge",logiclocked=True,res_place=True,core_only=True))
    pr_bsp.add_region(rect_region(31,62,33,165,name="fpga_top|inst_green_bs|bsp_interface_inst|ccip_std_afu|bsp_logic_inst|board_inst|ddr_board|ddr4a_cross_to_kernel",logiclocked=True,res_place=False,core_only=True))
    pr_bsp.add_region(rect_region(31,62,33,165,name="fpga_top|inst_green_bs|bsp_interface_inst|ccip_std_afu|bsp_logic_inst|board_inst|ddr_board|ddr4b_cross_to_kernel",logiclocked=True,res_place=False,core_only=True))

    print "#calling print_solution_hpr for bsp-interface"
    pr_bsp.print_solution_hpr(destination_hpr_outfilename_full)

    print "Done for now!"
    sys.exit(0)
    