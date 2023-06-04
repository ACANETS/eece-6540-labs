create_clock -name SMB_Clk -period 10000.000 -waveform {0.000 5000.000} [get_ports {SMB_Clk}]
set_clock_groups -exclusive -group [get_clocks {SMB_Clk}]

