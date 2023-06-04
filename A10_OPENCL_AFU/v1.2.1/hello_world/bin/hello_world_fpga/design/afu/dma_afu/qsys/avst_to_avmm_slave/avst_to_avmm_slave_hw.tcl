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


# 
# avst_to_avmm_slave "avst_to_avmm_slave" v1.0
#  2017.03.21.17:34:48
# 
# 

# 
# request TCL package from ACDS 17.0
# 
package require -exact qsys 17.0


# 
# module avst_to_avmm_slave
# 
set_module_property DESCRIPTION ""
set_module_property NAME avst_to_avmm_slave
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME avst_to_avmm_slave
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL avst_to_avmm_slave
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file avst_to_avmm_slave.sv SYSTEM_VERILOG PATH avst_to_avmm_slave.sv TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter AVMM_ADDR_WIDTH INTEGER 18
set_parameter_property AVMM_ADDR_WIDTH DEFAULT_VALUE 18
set_parameter_property AVMM_ADDR_WIDTH DISPLAY_NAME AVMM_ADDR_WIDTH
set_parameter_property AVMM_ADDR_WIDTH TYPE INTEGER
set_parameter_property AVMM_ADDR_WIDTH UNITS None
set_parameter_property AVMM_ADDR_WIDTH HDL_PARAMETER true
add_parameter AVMM_DATA_WIDTH INTEGER 64
set_parameter_property AVMM_DATA_WIDTH DEFAULT_VALUE 64
set_parameter_property AVMM_DATA_WIDTH DISPLAY_NAME AVMM_DATA_WIDTH
set_parameter_property AVMM_DATA_WIDTH TYPE INTEGER
set_parameter_property AVMM_DATA_WIDTH UNITS None
set_parameter_property AVMM_DATA_WIDTH HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges BOTH
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point avalon_streaming_sink
# 
add_interface avalon_streaming_sink avalon_streaming end
set_interface_property avalon_streaming_sink associatedClock clock
set_interface_property avalon_streaming_sink associatedReset reset
set_interface_property avalon_streaming_sink dataBitsPerSymbol 1
set_interface_property avalon_streaming_sink errorDescriptor ""
set_interface_property avalon_streaming_sink firstSymbolInHighOrderBits true
set_interface_property avalon_streaming_sink maxChannel 0
set_interface_property avalon_streaming_sink readyLatency 0
set_interface_property avalon_streaming_sink ENABLED true
set_interface_property avalon_streaming_sink EXPORT_OF ""
set_interface_property avalon_streaming_sink PORT_NAME_MAP ""
set_interface_property avalon_streaming_sink CMSIS_SVD_VARIABLES ""
set_interface_property avalon_streaming_sink SVD_ADDRESS_GROUP ""

add_interface_port avalon_streaming_sink in_data data Input "((((AVMM_ADDR_WIDTH + AVMM_DATA_WIDTH) + 2) - 1)) - (0) + 1"
add_interface_port avalon_streaming_sink in_ready ready Output 1
add_interface_port avalon_streaming_sink in_valid valid Input 1


# 
# connection point avalon_streaming_source
# 
add_interface avalon_streaming_source avalon_streaming start
set_interface_property avalon_streaming_source associatedClock clock
set_interface_property avalon_streaming_source associatedReset reset
set_interface_property avalon_streaming_source dataBitsPerSymbol 8
set_interface_property avalon_streaming_source errorDescriptor ""
set_interface_property avalon_streaming_source firstSymbolInHighOrderBits true
set_interface_property avalon_streaming_source maxChannel 0
set_interface_property avalon_streaming_source readyLatency 0
set_interface_property avalon_streaming_source ENABLED true
set_interface_property avalon_streaming_source EXPORT_OF ""
set_interface_property avalon_streaming_source PORT_NAME_MAP ""
set_interface_property avalon_streaming_source CMSIS_SVD_VARIABLES ""
set_interface_property avalon_streaming_source SVD_ADDRESS_GROUP ""

add_interface_port avalon_streaming_source out_data data Output 64
add_interface_port avalon_streaming_source out_ready ready Input 1
add_interface_port avalon_streaming_source out_valid valid Output 1


# 
# connection point avalon_master
# 
add_interface avalon_master avalon start
set_interface_property avalon_master addressUnits SYMBOLS
set_interface_property avalon_master associatedClock clock
set_interface_property avalon_master associatedReset reset
set_interface_property avalon_master bitsPerSymbol 8
set_interface_property avalon_master burstOnBurstBoundariesOnly false
set_interface_property avalon_master burstcountUnits WORDS
set_interface_property avalon_master doStreamReads false
set_interface_property avalon_master doStreamWrites false
set_interface_property avalon_master holdTime 0
set_interface_property avalon_master linewrapBursts false
set_interface_property avalon_master maximumPendingReadTransactions 0
set_interface_property avalon_master maximumPendingWriteTransactions 0
set_interface_property avalon_master minimumResponseLatency 1
set_interface_property avalon_master readLatency 0
set_interface_property avalon_master readWaitTime 1
set_interface_property avalon_master setupTime 0
set_interface_property avalon_master timingUnits Cycles
set_interface_property avalon_master waitrequestAllowance 0
set_interface_property avalon_master writeWaitTime 0
set_interface_property avalon_master ENABLED true
set_interface_property avalon_master EXPORT_OF ""
set_interface_property avalon_master PORT_NAME_MAP ""
set_interface_property avalon_master CMSIS_SVD_VARIABLES ""
set_interface_property avalon_master SVD_ADDRESS_GROUP ""

add_interface_port avalon_master avmm_waitrequest waitrequest Input 1
add_interface_port avalon_master avmm_readdata readdata Input "((AVMM_DATA_WIDTH - 1)) - (0) + 1"
add_interface_port avalon_master avmm_readdatavalid readdatavalid Input 1
add_interface_port avalon_master avmm_burstcount burstcount Output 1
add_interface_port avalon_master avmm_writedata writedata Output "((AVMM_DATA_WIDTH - 1)) - (0) + 1"
add_interface_port avalon_master avmm_address address Output "((AVMM_ADDR_WIDTH - 1)) - (0) + 1"
add_interface_port avalon_master avmm_write write Output 1
add_interface_port avalon_master avmm_read read Output 1
add_interface_port avalon_master avmm_byteenable byteenable Output "(((AVMM_DATA_WIDTH / 8) - 1)) - (0) + 1"

