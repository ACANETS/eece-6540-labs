# (C) 1992-2019 Intel Corporation.                            
# Intel, the Intel logo, Intel, MegaCore, NIOS II, Quartus and TalkBack words    
# and logos are trademarks of Intel Corporation or its subsidiaries in the U.S.  
# and/or other countries. Other marks and brands may be claimed as the property  
# of others. See Trademarks on intel.com for full list of Intel trademarks or    
# the Trademarks & Brands Names Database (if Intel) or See www.Intel.com/legal (if Altera) 
# Your use of Intel Corporation's design tools, logic functions and other        
# software and tools, and its AMPP partner logic functions, and any output       
# files any of the foregoing (including device programming or simulation         
# files), and any associated documentation or information are expressly subject  
# to the terms and conditions of the Altera Program License Subscription         
# Agreement, Intel MegaCore Function License Agreement, or other applicable      
# license agreement, including, without limitation, that your use is for the     
# sole purpose of programming logic devices manufactured by Intel and sold by    
# Intel or its authorized distributors.  Please refer to the applicable          
# agreement for further details.                                                 


#Full compiles are not supported on Windows
switch $tcl_platform(platform) {
  windows {
    post_message -type error "Full compiles to generate hardware for the FPGA are available on supported Linux platforms only. Please add -rtl to your invocation of aoc to compile without building hardware. Otherwise please run your compile on a supported Linux distribution."
    exit 2
  }
  default {
    #Get revision name from quartus args
    if { [llength $quartus(args)] > 0 } {
      set revision_name [lindex $quartus(args) 0]
    } else {
      set revision_name import
    }
    post_message "Compiling revision $revision_name"
    qexec "bash build/run.sh $revision_name"
  }
}
