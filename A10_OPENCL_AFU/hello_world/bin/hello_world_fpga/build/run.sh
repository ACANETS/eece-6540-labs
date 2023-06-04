#!/bin/bash

# (C) 2019 Intel Corporation. All rights reserved.
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

BSP_FLOW="$1"

#get exact script path
SCRIPT_PATH=$(readlink -f "${BASH_SOURCE[0]}")
#get director of script path
SCRIPT_DIR_PATH="$(dirname "$SCRIPT_PATH")"

cd "$SCRIPT_DIR_PATH"

#test packager bin first to make sure it is available and working and fail
#early if it can't run.
#it would be frustrating to find out at the end of the compilation
ADAPT_PACKAGER_BIN="python2.7 ./tools/packager.pyz"
FLOW_SUCCESS=1
PACKAGER_OUTPUT=$($ADAPT_PACKAGER_BIN)
FLOW_SUCCESS=$?
if [ $FLOW_SUCCESS != 0 ]; then
	echo "ERROR: packager check failed with output '$PACKAGER_OUTPUT'"
	exit 1
fi

#make sure bbs files exist
if [ ! -f "dcp.qdb" ]; then
	echo "ERROR: BSP is not setup"
fi

#copy quartus.ini
cp ../quartus.ini .

#import opencl kernel files
quartus_sh -t scripts/import_opencl_kernel.tcl 

#check for bypass/alternative flows
if [ "$DCP_BYPASS_OPENCL_RUN_SCRIPT" != "" ]; then
	sh $DCP_BYPASS_OPENCL_RUN_SCRIPT
	exit $?
fi

#add BBBs to quartus pr project
quartus_sh -t add_bbb_to_pr_project.tcl

cp ../afu_opencl_kernel.qsf .

qsys-generate -syn --quartus-project=dcp --rev=afu_opencl_kernel board.qsys
# adding board.qsys and corresponding .ip parameterization files to opencl_bsp_ip.qsf
qsys-archive --quartus-project=dcp --rev=afu_opencl_kernel --add-to-project board.qsys

#append kernel_system qsys/ip assignments to afu_default revision
rm -f kernel_system_qsf_append.txt
echo >> kernel_system_qsf_append.txt
grep -A10000 OPENCL_KERNEL_ASSIGNMENTS_START_HERE afu_opencl_kernel.qsf >> kernel_system_qsf_append.txt
echo >> kernel_system_qsf_append.txt

cat kernel_system_qsf_append.txt >> afu_default.qsf
cat kernel_system_qsf_append.txt >> afu_base.qsf
cat kernel_system_qsf_append.txt >> afu_import.qsf

# compile project
# =====================
if [ $BSP_FLOW == "default" ]
then
quartus_sh -t a10_partial_reconfig/flow.tcl -nobasecheck -setup_script a10_partial_reconfig/setup.tcl -impl afu_default
FLOW_SUCCESS=$?
else
  echo "Compiling $BSP_FLOW revision flow..."
  quartus_sh -t compile_script.tcl $BSP_FLOW
  FLOW_SUCCESS=$?
fi

# Report Timing
# =============
if [ $FLOW_SUCCESS -eq 0 ]
then
  quartus_sh -t scripts/adjust_plls_mcp.tcl dcp afu_$BSP_FLOW
else
    echo "ERROR: pll timing script failed."
    exit 1
fi

#run packager tool to create GBS
BBS_ID_FILE="fme-ifc-id.txt"
if [ -f "$BBS_ID_FILE" ]; then
	FME_IFC_ID=`cat $BBS_ID_FILE`
else
    echo "ERROR: fme id not found."
    exit 1
fi

PLL_METADATA=""
PLL_METADATA_FILE="pll_metadata.txt"
if [ -f "$PLL_METADATA_FILE" ]; then
	PLL_METADATA=`cat $PLL_METADATA_FILE`
fi

rm -f afu.gbs
$ADAPT_PACKAGER_BIN create-gbs \
	--rbf ./output_files/afu_$BSP_FLOW.green_region.rbf \
	--gbs ./output_files/afu_$BSP_FLOW.gbs \
	--afu-json opencl_afu.json \
	--set-value \
		interface-uuid:$FME_IFC_ID \
		$PLL_METADATA
FLOW_SUCCESS=$?
if [ $FLOW_SUCCESS != 0 ]; then
	echo "ERROR: packager tool failed to create .gbs file."
	exit 1
fi

rm -rf fpga.bin

gzip -9c ./output_files/afu_$BSP_FLOW.gbs > afu_$BSP_FLOW.gbs.gz
aocl binedit fpga.bin create
  aocl binedit fpga.bin add .acl.gbs.gz ./afu_$BSP_FLOW.gbs.gz

if [ -f afu_$BSP_FLOW.failing_clocks.rpt ]; then
	aocl binedit fpga.bin add .failing_clocks.rpt ./afu_$BSP_FLOW.failing_clocks.rpt
	cp ./afu_$BSP_FLOW.failing_clocks.rpt ../
fi

if [ -f afu_$BSP_FLOW.failing_paths.rpt ]; then
	aocl binedit fpga.bin add .failing_paths.rpt ./afu_$BSP_FLOW.failing_paths.rpt
 	cp ./afu_$BSP_FLOW.failing_paths.rpt ../
fi

if [ ! -f fpga.bin ]; then
	echo "ERROR: no fpga.bin found.  FPGA compilation failed!"
	exit 1
fi

#copy fpga.bin to parent directory so aoc flow can find it
cp fpga.bin ../
cp acl_quartus_report.txt ../

echo ""
echo "==========================================================================="
echo "OpenCL AFU compilation complete"
echo "==========================================================================="
echo ""
