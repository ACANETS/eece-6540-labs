# (C) 2001-2016 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


# $Id: //depot/adapt/rel/19.1_dcp_1.2.1/platform/dcp_1.0-skx/design/remote_stp/QSYS_IPs/PR/ip/sld_hub_controller_system_without_sld_ep/altera_streaming_sld_hub_controller_without_sldep/altera_streaming_sld_hub_controller_without_sldep_hw.tcl#2 $
# $Revision: #2 $
# $Date: 2019/09/21 $
# $Author: thofion $

# +-----------------------------------
# | request TCL package from ACDS 9.1
# |
package require -exact sopc 9.1
# |
# +-----------------------------------

# +-----------------------------------
# | module altera_streaming_sld_hub_controller_without_sldep
# |
set_module_property NAME altera_streaming_sld_hub_controller_without_sldep
set_module_property AUTHOR "Altera Corporation"
set_module_property VERSION 16.0
set_module_property GROUP "Basic Functions/Simulation; Debug and Verification/Debug and Performance"
set_module_property DISPLAY_NAME "SLD Hub Controller Without SLD Endpoint"
set_module_property INTERNAL false
set_module_property DESCRIPTION ""
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property COMPOSE_CALLBACK compose
set_module_property ANALYZE_HDL false
set_module_property OPAQUE_ADDRESS_MAP false

add_parameter MANUAL_DEBUG_FABRIC INTEGER 1
set_parameter_property MANUAL_DEBUG_FABRIC DISPLAY_NAME "Export interfaces for connection to manual debug fabric"
set_parameter_property MANUAL_DEBUG_FABRIC ALLOWED_RANGES {"0:No" "1:Yes"}
set_parameter_property MANUAL_DEBUG_FABRIC new_instance_value 0

add_parameter HOST_LINK_NAME STRING {}
set_parameter_property HOST_LINK_NAME DISPLAY_NAME "Automatic connection name"
set_parameter_property HOST_LINK_NAME UNITS None
set_parameter_property HOST_LINK_NAME DESCRIPTION "Name of automatic host link to use"
set_parameter_property HOST_LINK_NAME AFFECTS_GENERATION true
set_parameter_property HOST_LINK_NAME HDL_PARAMETER false

add_parameter ENABLE_JTAG_IO_SELECTION INTEGER 0
set_parameter_property ENABLE_JTAG_IO_SELECTION DEFAULT_VALUE 0
set_parameter_property ENABLE_JTAG_IO_SELECTION DISPLAY_NAME ENABLE_JTAG_IO_SELECTION
set_parameter_property ENABLE_JTAG_IO_SELECTION TYPE BOOLEAN
set_parameter_property ENABLE_JTAG_IO_SELECTION HDL_PARAMETER true
set_parameter_property ENABLE_JTAG_IO_SELECTION AFFECTS_ELABORATION true
set_parameter_property ENABLE_JTAG_IO_SELECTION STATUS experimental
# |
# +-----------------------------------

#
# documentation
#
add_documentation_link "System Debugging Tools Overview UG" "http://www.altera.com/literature/hb/qts/qts_qii53027.pdf"
add_documentation_link "Altera Virtual JTAG (altera_virtual_jtag) IP Core User Guide" "http://www.altera.com/literature/ug/ug_virtualjtag.pdf"

proc compose {} {
  #  Clock Source 
  add_instance clock_bridge altera_clock_bridge  

  add_instance reset_bridge altera_reset_bridge
  set_instance_parameter reset_bridge SYNCHRONOUS_EDGES deassert

  add_interface clk clock end
  set_interface_property clk export_of clock_bridge.in_clk

  # Core instance
  add_instance core altera_streaming_sld_hub_controller_core_without_sldep
  set_instance_parameter core ENABLE_JTAG_IO_SELECTION 0

  # Exported JTAG
  add_interface          exported_jtag conduit start
  set_interface_property exported_jtag export_of core.exported_jtag
  set_interface_property exported_jtag port_name_map {
      exported_tck exported_tck 
      exported_tms exported_tms
      exported_tdi exported_tdi
      exported_tdo exported_tdo
  }

  set manual [get_parameter_value MANUAL_DEBUG_FABRIC]
  set host_link_name [get_parameter_value HOST_LINK_NAME]
  set jtag_io_select [get_parameter_value ENABLE_JTAG_IO_SELECTION]

  if {$manual} {
    # Reset
    add_interface reset reset end
    set_interface_property reset export_of reset_bridge.in_reset

    # Manual fabric modes
    add_interface sink avalon_streaming end
    set_interface_property sink export_of core.sink

    set_interface_assignment sink debug.interfaceGroup {associatedT2h source} 
  
    add_interface source avalon_streaming start
    set_interface_property source export_of core.source

    if {$jtag_io_select} {
      set_instance_parameter core ENABLE_JTAG_IO_SELECTION 1

      add_interface csr avalon end
      set_interface_property csr export_of core.csr
    }
  } else {
    add_instance endpoint altera_avalon_st_debug_agent_endpoint
    set_instance_parameter_value endpoint CHANNEL_WIDTH 0
    set_instance_parameter_value endpoint READY_LATENCY 0
    set_instance_parameter_value endpoint MFR_CODE 110
    set_instance_parameter_value endpoint TYPE_CODE 259
    set_instance_parameter_value endpoint PREFER_HOST $host_link_name

    add_connection clock_bridge.out_clk endpoint.clk
    add_connection endpoint.reset reset_bridge.in_reset
    add_connection endpoint.h2t core.sink
    add_connection core.source endpoint.t2h
  }

  # Clock connections
  add_connection clock_bridge.out_clk/core.clk
  add_connection clock_bridge.out_clk/reset_bridge.clk
  # Reset connections
  add_connection reset_bridge.out_reset/core.reset
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/mwh1410385117325/mwh1410384469524
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
