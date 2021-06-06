#start from scratch
clear -all

set top ras_controller

analyze -sv09       \
    +libext+.vs+.v+.sv+vh+.svh \
    +incdir+./  \
    +define+FPV_ON \
    ./ras_controller.v   \
    
    
set elab_cmd "elaborate -top $top -latchHandling -bbox_mul 5000"
eval $elab_cmd


#clocks and resets
clock Clk_32UI
reset !Resetb


#engine parameters
