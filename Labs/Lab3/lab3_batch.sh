#############################################################################################################
# Arria 10 Devstack version 1.2.1
# **Adjust commands to your own needs.**
#
# sample batch file from Intel FPGA DevCloud
# Yan Luo modified for Lab 3 of EECE.6540 at UMass Lowell
#############################################################################################################

# Initial Setup
source /data/intel_fpga/devcloudLoginToolSetup.sh
tools_setup -t A10DS
# Job will exit if directory already exists; no overwrite. No error message.
#[ ! -d ~/A10_OPENCL_AFU/v1.2.1 ] && mkdir -p ~/A10_OPENCL_AFU/v1.2.1 || exit 0

# Check Arria 10 PAC card connectivity
aocl diagnose
error_check

# Running project in Emulation mode
#cd hello_world
#aoc -march=emulator -v device/hello_world.cl -o bin/hello_world_emulation.aocx
# Creating symbolic link to emulation .aocx
#ln -sf hello_world_emulation.aocx bin/hello_world.aocx
#make
# Run host code for version 1.2.1
#./bin/host -emulator
#error_check

# Running project in FPGA Hardware Mode (this takes approximately 1 hour)
# !!! NOTE !!!
# you might need to modify this path, depending on where you put your Lab3
cd ~/eece-6540-labs/Labs/Lab3
rm -rf bin/
mkdir bin
aoc device/boardtest.cl -o bin/boardtest.aocx -board=pac_a10
make bin/boardtest_host
# Relink to hardware .aocx
#ln -sf boardtest.aocx bin/boardtest.aocx
# Availavility of Acceleration cards
aoc -list-boards
error_check
# Get device name
aocl diagnose
error_check
