/* (C) 1992-2016 Intel Corporation.                             */
/* Intel, the Intel logo, Intel, MegaCore, NIOS II, Quartus and TalkBack words     */
/* and logos are trademarks of Intel Corporation or its subsidiaries in the U.S.   */
/* and/or other countries. Other marks and brands may be claimed as the property   */
/* of others. See Trademarks on intel.com for full list of Intel trademarks or     */
/* the Trademarks & Brands Names Database (if Intel) or See www.Intel.com/legal (if Altera)  */
/* Your use of Intel Corporation's design tools, logic functions and other         */
/* software and tools, and its AMPP partner logic functions, and any output        */
/* files any of the foregoing (including device programming or simulation          */
/* files), and any associated documentation or information are expressly subject   */
/* to the terms and conditions of the Altera Program License Subscription          */
/* Agreement, Intel MegaCore Function License Agreement, or other applicable       */
/* license agreement, including, without limitation, that your use is for the      */
/* sole purpose of programming logic devices manufactured by Intel and sold by     */
/* Intel or its authorized distributors.  Please refer to the applicable           */
/* agreement for further details.                                                  */
    

#include "CL/opencl.h"

struct speed {
  float fastest;
  float slowest;
  float average;
  float total;
};
void freeDeviceMemory();
void hostspeed_ocl_device_init( cl_platform_id platform,
    cl_device_id device,
    cl_context context,
    cl_command_queue queue, 
    size_t maxbytes);
struct speed ocl_readspeed(char * buf,size_t block_bytes,size_t bytes);
struct speed ocl_writespeed(char * buf,size_t block_bytes,size_t bytes);
size_t ocl_test_all_global_memory( );
