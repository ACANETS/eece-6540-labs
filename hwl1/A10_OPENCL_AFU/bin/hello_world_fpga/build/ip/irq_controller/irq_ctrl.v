// (C) 1992-2017 Intel Corporation.                            
// Intel, the Intel logo, Intel, MegaCore, NIOS II, Quartus and TalkBack words    
// and logos are trademarks of Intel Corporation or its subsidiaries in the U.S.  
// and/or other countries. Other marks and brands may be claimed as the property  
// of others. See Trademarks on intel.com for full list of Intel trademarks or    
// the Trademarks & Brands Names Database (if Intel) or See www.Intel.com/legal (if Altera) 
// Your use of Intel Corporation's design tools, logic functions and other        
// software and tools, and its AMPP partner logic functions, and any output       
// files any of the foregoing (including device programming or simulation         
// files), and any associated documentation or information are expressly subject  
// to the terms and conditions of the Altera Program License Subscription         
// Agreement, Intel MegaCore Function License Agreement, or other applicable      
// license agreement, including, without limitation, that your use is for the     
// sole purpose of programming logic devices manufactured by Intel and sold by    
// Intel or its authorized distributors.  Please refer to the applicable          
// agreement for further details.                                                 

module irq_ctrl
(
// Slave Inteface
   input            Clk_i,             // MSI-X structure slave
   input            Rstn_i,          
 
// IRQ interface               
   input   [31:0]   Irq_i,                           
 
// PCIe HIP interface
   output           Irq_o,
 
// Irq Bridge Interface
   input            IrqRead_i,          
   output  [31:0]   IrqReadData_o,
 
// Irq Mask
  input    [31:0]   MaskWritedata_i,
  input             MaskRead_i,
  input             MaskWrite_i,
  input    [3:0]    MaskByteenable_i,
  output   [31:0]   MaskReaddata_o,
  output            MaskWaitrequest_o
);
      
   wire    [31:0]   Irq_masked;

   assign Irq_o = |Irq_masked;

/// IRQ Bridge
irq_bridge irq_ports
(
    .clk(Clk_i),
    .read(IrqRead_i),
    .rst_n(Rstn_i),
    .readdata(IrqReadData_o),
    .irq_i(Irq_i)
);

/// IRQ Mask
irq_ena irq_enable_mask
(
    .clk(Clk_i),
    .resetn(Rstn_i),
    .irq(Irq_i),
    .slave_writedata(MaskWritedata_i),
    .slave_read(MaskRead_i),
    .slave_write(MaskWrite_i),
    .slave_byteenable(MaskByteenable_i),
    .slave_readdata(MaskReaddata_o),
    .slave_waitrequest(MaskWaitrequest_o),
    .irq_out(Irq_masked)
);

endmodule              
