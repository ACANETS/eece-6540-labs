Quickstart
run:
python gen_dcp_10_skx_floorplan.py > output.txt
copy text from output.txt to dcp.qsf and replace old floorplan stuff

#
#
#  Example Implementation
#
#

if __name__ == '__main__':                                       
	pr = logiclock_solver(partitionname="green_region",name="fpga_top|inst_green_bs")
	pr.add_region(rect_region(0,47,38,167,name="BBS",logiclocked=False))
	pr.add_region(rect_region(139,0,142,4,name="mem|ddr4a",logiclocked=True,res_place=False,core_only=True))
	pr.add_region(rect_region(129,73,138,90,name="mem|ddr4a",logiclocked=True,res_place=False,core_only=True))
	pr.add_region(rect_region(129,128,138,145,name="mem|ddr4a",logiclocked=True,res_place=False,core_only=True))
	pr.add_region(rect_region(139,0,142,4,name="mem|ddr4b",logiclocked=True,res_place=False,core_only=True))
	pr.add_region(rect_region(129,73,138,90,name="mem|ddr4b",logiclocked=True,res_place=False,core_only=True))
	pr.add_region(rect_region(129,128,138,145,name="mem|ddr4b",logiclocked=True,res_place=False,core_only=True))
	pr.print_solution()

Output:

#####################################################
# Main PR Partition -- green_region
#####################################################
set_instance_assignment -name PARTITION green_region -to fpga_top|inst_green_bs
set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to fpga_top|inst_green_bs
set_instance_assignment -name RESERVE_PLACE_REGION ON -to fpga_top|inst_green_bs
set_instance_assignment -name PLACE_REGION "0 0 138 46;0 168 224 224;39 47 128 167;129 47 224 72;129 91 224 127;129 146 224 167;139 5 224 46;139 73 224 90;139 128 224 145;143 0 224 4;" -to fpga_top|inst_green_bs
set_instance_assignment -name ROUTE_REGION "0 0 224 224" -to fpga_top|inst_green_bs

#####################################################
# Logic Locked Static Region -- mem|ddr4a
#####################################################
set_instance_assignment -name RESERVE_PLACE_REGION ON -to mem|ddr4a
set_instance_assignment -name CORE_ONLY_PLACE_REGION OFF -to mem|ddr4a
set_instance_assignment -name RESERVE_PLACE_REGION ON -to mem|ddr4a
set_instance_assignment -name PLACE_REGION "139 0 142 4;129 73 138 90;129 128 138 145;" -to mem|ddr4a

#####################################################
# Logic Locked Static Region -- mem|ddr4b
#####################################################
set_instance_assignment -name RESERVE_PLACE_REGION ON -to mem|ddr4b
set_instance_assignment -name CORE_ONLY_PLACE_REGION OFF -to mem|ddr4b
set_instance_assignment -name RESERVE_PLACE_REGION ON -to mem|ddr4b
set_instance_assignment -name PLACE_REGION "139 0 142 4;129 73 138 90;129 128 138 145;" -to mem|ddr4b

