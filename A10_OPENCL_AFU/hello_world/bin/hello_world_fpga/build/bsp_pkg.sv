/*
 *  This file contains SystemVerilog package definitions for
 *  the PAC OpenCL BSP
*/

package bsp_pkg;

	parameter CCIP_AVMM_NUM_IRQ_USED = 3; //DMA_0, kernel, DMA_1
	parameter CCIP_DMA_0_IRQ_BIT    = 0;
	parameter CCIP_KERNEL_IRQ_BIT   = 1;
	parameter CCIP_DMA_1_IRQ_BIT    = 2;

endpackage : bsp_pkg
