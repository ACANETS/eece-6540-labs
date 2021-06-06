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
# avst_to_avmm_master "avst_to_avmm_master" v1.0
#  2017.05.02.22:10:28
# 
# 

# 
# request TCL package from ACDS 17.0
# 
package require -exact qsys 17.0


# 
# module avst_to_avmm_master
# 
set_module_property DESCRIPTION ""
set_module_property NAME avst_to_avmm_master
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME avst_to_avmm_master
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL avst_to_avmm_master
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file avst_to_avmm_master.sv SYSTEM_VERILOG PATH avst_to_avmm_master.sv TOP_LEVEL_FILE

set_module_property VALIDATION_CALLBACK validate_me
set_module_property ELABORATION_CALLBACK elaborate_me

# 
# parameters
# 
add_parameter AVMM_ADDR_WIDTH INTEGER 48
set_parameter_property AVMM_ADDR_WIDTH DEFAULT_VALUE 48
set_parameter_property AVMM_ADDR_WIDTH DISPLAY_NAME AVMM_ADDR_WIDTH
set_parameter_property AVMM_ADDR_WIDTH TYPE INTEGER
set_parameter_property AVMM_ADDR_WIDTH UNITS None
set_parameter_property AVMM_ADDR_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property AVMM_ADDR_WIDTH HDL_PARAMETER true
add_parameter AVMM_DATA_WIDTH INTEGER 512
set_parameter_property AVMM_DATA_WIDTH DEFAULT_VALUE 512
set_parameter_property AVMM_DATA_WIDTH DISPLAY_NAME AVMM_DATA_WIDTH
set_parameter_property AVMM_DATA_WIDTH TYPE INTEGER
set_parameter_property AVMM_DATA_WIDTH UNITS None
set_parameter_property AVMM_DATA_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property AVMM_DATA_WIDTH HDL_PARAMETER true
add_parameter AVMM_BURST_WIDTH INTEGER 1
set_parameter_property AVMM_BURST_WIDTH DEFAULT_VALUE 1
set_parameter_property AVMM_BURST_WIDTH DISPLAY_NAME AVMM_BURST_WIDTH
set_parameter_property AVMM_BURST_WIDTH TYPE INTEGER
set_parameter_property AVMM_BURST_WIDTH UNITS None
set_parameter_property AVMM_BURST_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property AVMM_BURST_WIDTH HDL_PARAMETER true
add_parameter INGORE_BYTE_ENABLE INTEGER 1
set_parameter_property INGORE_BYTE_ENABLE DEFAULT_VALUE 1
set_parameter_property INGORE_BYTE_ENABLE DISPLAY_NAME INGORE_BYTE_ENABLE
set_parameter_property INGORE_BYTE_ENABLE TYPE INTEGER
set_parameter_property INGORE_BYTE_ENABLE ENABLED false
set_parameter_property INGORE_BYTE_ENABLE UNITS None
set_parameter_property INGORE_BYTE_ENABLE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property INGORE_BYTE_ENABLE HDL_PARAMETER true
add_parameter INPUT_AVST_WIDTH INTEGER 512 ""
set_parameter_property INPUT_AVST_WIDTH DEFAULT_VALUE 512
set_parameter_property INPUT_AVST_WIDTH DISPLAY_NAME INPUT_AVST_WIDTH
set_parameter_property INPUT_AVST_WIDTH TYPE INTEGER
set_parameter_property INPUT_AVST_WIDTH ENABLED false
set_parameter_property INPUT_AVST_WIDTH UNITS None
set_parameter_property INPUT_AVST_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property INPUT_AVST_WIDTH DESCRIPTION ""
set_parameter_property INPUT_AVST_WIDTH HDL_PARAMETER true
add_parameter AVST_BYTE_ENABLE_WIDTH INTEGER 0 ""
set_parameter_property AVST_BYTE_ENABLE_WIDTH DEFAULT_VALUE 0
set_parameter_property AVST_BYTE_ENABLE_WIDTH DISPLAY_NAME AVST_BYTE_ENABLE_WIDTH
set_parameter_property AVST_BYTE_ENABLE_WIDTH TYPE INTEGER
set_parameter_property AVST_BYTE_ENABLE_WIDTH ENABLED false
set_parameter_property AVST_BYTE_ENABLE_WIDTH UNITS None
set_parameter_property AVST_BYTE_ENABLE_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property AVST_BYTE_ENABLE_WIDTH DESCRIPTION ""
set_parameter_property AVST_BYTE_ENABLE_WIDTH HDL_PARAMETER true
add_parameter AVST_OUTPUT_CONTROL_WIDTH INTEGER 1 ""
set_parameter_property AVST_OUTPUT_CONTROL_WIDTH DEFAULT_VALUE 1
set_parameter_property AVST_OUTPUT_CONTROL_WIDTH DISPLAY_NAME AVST_OUTPUT_CONTROL_WIDTH
set_parameter_property AVST_OUTPUT_CONTROL_WIDTH TYPE INTEGER
set_parameter_property AVST_OUTPUT_CONTROL_WIDTH ENABLED false
set_parameter_property AVST_OUTPUT_CONTROL_WIDTH UNITS None
set_parameter_property AVST_OUTPUT_CONTROL_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property AVST_OUTPUT_CONTROL_WIDTH DESCRIPTION ""
set_parameter_property AVST_OUTPUT_CONTROL_WIDTH HDL_PARAMETER true
add_parameter OUTPUT_AVST_WIDTH INTEGER 564 ""
set_parameter_property OUTPUT_AVST_WIDTH DEFAULT_VALUE 564
set_parameter_property OUTPUT_AVST_WIDTH DISPLAY_NAME OUTPUT_AVST_WIDTH
set_parameter_property OUTPUT_AVST_WIDTH TYPE INTEGER
set_parameter_property OUTPUT_AVST_WIDTH ENABLED false
set_parameter_property OUTPUT_AVST_WIDTH UNITS None
set_parameter_property OUTPUT_AVST_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property OUTPUT_AVST_WIDTH DESCRIPTION ""
set_parameter_property OUTPUT_AVST_WIDTH HDL_PARAMETER true
set_parameter_property OUTPUT_AVST_WIDTH DERIVED true


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
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point avmm
# 
add_interface avmm avalon end
set_interface_property avmm addressUnits SYMBOLS
set_interface_property avmm associatedClock clock
set_interface_property avmm associatedReset reset
set_interface_property avmm bitsPerSymbol 8
set_interface_property avmm bridgedAddressOffset ""
set_interface_property avmm bridgesToMaster ""
set_interface_property avmm burstOnBurstBoundariesOnly false
set_interface_property avmm burstcountUnits WORDS
set_interface_property avmm explicitAddressSpan 0
set_interface_property avmm holdTime 0
set_interface_property avmm linewrapBursts false
set_interface_property avmm maximumPendingReadTransactions 64
set_interface_property avmm maximumPendingWriteTransactions 0
set_interface_property avmm minimumResponseLatency 1
set_interface_property avmm readLatency 0
set_interface_property avmm readWaitTime 1
set_interface_property avmm setupTime 0
set_interface_property avmm timingUnits Cycles
set_interface_property avmm transparentBridge false
set_interface_property avmm waitrequestAllowance 0
set_interface_property avmm writeWaitTime 0
set_interface_property avmm ENABLED true
set_interface_property avmm EXPORT_OF ""
set_interface_property avmm PORT_NAME_MAP ""
set_interface_property avmm CMSIS_SVD_VARIABLES ""
set_interface_property avmm SVD_ADDRESS_GROUP ""

add_interface_port avmm avmm_waitrequest waitrequest Output 1
add_interface_port avmm avmm_readdata readdata Output "((AVMM_DATA_WIDTH - 1)) - (0) + 1"
add_interface_port avmm avmm_readdatavalid readdatavalid Output 1
add_interface_port avmm avmm_writedata writedata Input "((AVMM_DATA_WIDTH - 1)) - (0) + 1"
add_interface_port avmm avmm_address address Input "((AVMM_ADDR_WIDTH - 1)) - (0) + 1"
add_interface_port avmm avmm_write write Input 1
add_interface_port avmm avmm_read read Input 1
add_interface_port avmm avmm_burstcount burstcount Input "((AVMM_BURST_WIDTH - 1)) - (0) + 1"
add_interface_port avmm avmm_byteenable byteenable Input "(((AVMM_DATA_WIDTH / 8) - 1)) - (0) + 1"
set_interface_assignment avmm embeddedsw.configuration.isFlash 0
set_interface_assignment avmm embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avmm embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avmm embeddedsw.configuration.isPrintableDevice 0


# 
# connection point avalon_streaming_sink
# 
add_interface avalon_streaming_sink avalon_streaming end
set_interface_property avalon_streaming_sink associatedClock clock
set_interface_property avalon_streaming_sink associatedReset reset
set_interface_property avalon_streaming_sink dataBitsPerSymbol 512
set_interface_property avalon_streaming_sink errorDescriptor ""
set_interface_property avalon_streaming_sink firstSymbolInHighOrderBits true
set_interface_property avalon_streaming_sink maxChannel 0
set_interface_property avalon_streaming_sink readyLatency 0
set_interface_property avalon_streaming_sink ENABLED true
set_interface_property avalon_streaming_sink EXPORT_OF ""
set_interface_property avalon_streaming_sink PORT_NAME_MAP ""
set_interface_property avalon_streaming_sink CMSIS_SVD_VARIABLES ""
set_interface_property avalon_streaming_sink SVD_ADDRESS_GROUP ""

add_interface_port avalon_streaming_sink avst_rd_rsp_data data Input 512
add_interface_port avalon_streaming_sink avst_rd_rsp_valid valid Input 1
add_interface_port avalon_streaming_sink avst_rd_rsp_ready ready Output 1


# 
# connection point avalon_streaming_source
# 
add_interface avalon_streaming_source avalon_streaming start
set_interface_property avalon_streaming_source associatedClock clock
set_interface_property avalon_streaming_source associatedReset reset
set_interface_property avalon_streaming_source dataBitsPerSymbol "(OUTPUT_AVST_WIDTH)"
set_interface_property avalon_streaming_source errorDescriptor ""
set_interface_property avalon_streaming_source firstSymbolInHighOrderBits true
set_interface_property avalon_streaming_source maxChannel 0
set_interface_property avalon_streaming_source readyLatency 0
set_interface_property avalon_streaming_source ENABLED true
set_interface_property avalon_streaming_source EXPORT_OF ""
set_interface_property avalon_streaming_source PORT_NAME_MAP ""
set_interface_property avalon_streaming_source CMSIS_SVD_VARIABLES ""
set_interface_property avalon_streaming_source SVD_ADDRESS_GROUP ""


add_interface_port avalon_streaming_source avst_avcmd_ready ready Input 1
add_interface_port avalon_streaming_source avst_avcmd_valid valid Output 1
add_interface_port avalon_streaming_source avst_avcmd_data data Output "(OUTPUT_AVST_WIDTH)"

proc validate_me {} {
  set address_width [get_parameter_value AVMM_ADDR_WIDTH]
  set data_width [get_parameter_value AVMM_DATA_WIDTH]
  set burst_width [get_parameter_value AVMM_BURST_WIDTH]
  set control_width [get_parameter_value AVST_OUTPUT_CONTROL_WIDTH]
  set output_width [expr $address_width + $data_width +  $burst_width + $control_width]
  # output commands are a combination of the AvMM address, data, burst, and control (read/write)
  set_parameter_value OUTPUT_AVST_WIDTH $output_width
}

proc elaborate_me {} {
  set_interface_property avalon_streaming_source dataBitsPerSymbol [get_parameter_value OUTPUT_AVST_WIDTH]
}


