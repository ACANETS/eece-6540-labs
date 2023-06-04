#create PLL clocks based on worst-case timing for all HSSI modes (must be before derive_pll_clocks command)
create_clock -name {hssi_pll_r_outclk0} -period 390.625MHz {inst_fiu_top|inst_hssi_eth|pll_r|xcvr_fpll_a10_0|outclk0}
create_clock -name {hssi_pll_r_outclk1} -period 312.5MHz {inst_fiu_top|inst_hssi_eth|pll_r|xcvr_fpll_a10_0|outclk1}
create_clock -name {hssi_pll_t_outclk0} -period 390.625MHz {inst_fiu_top|inst_hssi_eth|pll_t|xcvr_fpll_a10_0|outclk0}
create_clock -name {hssi_pll_t_outclk1} -period 312.5MHz {inst_fiu_top|inst_hssi_eth|pll_t|xcvr_fpll_a10_0|outclk1}

if {$::quartus(nameofexecutable) == "quartus_fit"} {
    set_max_delay -to   [get_registers *rx_capture*] 2
    set_max_delay -from [get_registers *rx_req*] 2
    set_max_delay -from [get_registers *tx_launch*] 2
    set_max_delay -from [get_registers *tx_valid*] 2        
    set_max_delay -from [get_registers *tx_digitalreset_r*] 2
    set_max_delay -from [get_registers *rx_digitalreset_r*] 2
}

if {$::quartus(nameofexecutable) == "quartus_sta"} {
    set_false_path -from [get_registers {inst_green_bs|prz0|tx_digitalreset_r[*]}] -to [get_registers {inst_green_bs|prz0|tx_enh_data_valid_c}]
    set_false_path -to [get_registers {inst_green_bs|prz0|*_meta*}]
}  

