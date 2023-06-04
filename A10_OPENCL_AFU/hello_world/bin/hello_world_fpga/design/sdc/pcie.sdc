#**************************************************************
# Set False Path
#**************************************************************
# Synchronizer for RCiEP and Extra BAR Lock register bits from SMB.

# PCIe0
set_false_path -to [get_registers {*inst_pcie0_ccib_top*cr_extrabarlock_sync1*} ]
set_false_path -to [get_registers {*inst_pcie0_ccib_top*cr_rciep_sync1*} ]
