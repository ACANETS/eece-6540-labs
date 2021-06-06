#start from scratch
clear -all

set top ap_state_changer

analyze -sv09       \
    +libext+.vs+.v+.sv+vh+.svh \
    +incdir+./  \
    +define+FPV_ON \
    ./ap_state_changer.sv   \
    
    
set elab_cmd "elaborate -top $top -latchHandling -bbox_mul 5000"
eval $elab_cmd


#clocks and resets
clock clk
reset !resetn


#engine parameters
