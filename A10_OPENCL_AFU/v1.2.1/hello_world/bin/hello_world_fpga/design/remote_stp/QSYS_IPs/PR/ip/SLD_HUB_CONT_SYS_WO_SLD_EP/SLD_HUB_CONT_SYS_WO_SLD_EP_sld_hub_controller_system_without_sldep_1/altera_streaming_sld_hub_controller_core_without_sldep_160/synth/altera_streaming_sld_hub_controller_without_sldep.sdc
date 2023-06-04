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


# This pattern must match all sld hub controller clocks (altclkctrl 
# output), no matter what the device family.
set sld_hub_clk_name {*altera_streaming_sld_hub_controller_*_altclkctrl_altclkctrl_component|sd1|outclk}

# Clocks are created solely for the purpose of declaring them to be
# asynchronous from all other clocks. The clock frequency is required,
# but is arbitrary.
set arbitrary_period 10

set shc_clocks [ get_pins -compatibility_mode $sld_hub_clk_name ]
set shc_clock_count 0
foreach_in_collection shc_clock $shc_clocks {
  set cn [ get_pin_info -name $shc_clock ]
  set clock_group_name altera_reserved_shc_clock$shc_clock_count
  # Note: if there are multiple sld hub controllers in the design,
  # their clocks will be created multiple times, and warnings will be issued.
  # Those warnings can be ignored.
  create_clock -name $clock_group_name -period $arbitrary_period $cn

  # "The use of a singe -group option test TQ to cut this group of 
  # clocks from all other clocks in the design, including clocks that 
  # are creatred in the future."
  set_clock_groups -asynchronous -group $clock_group_name
  incr shc_clock_count
}

