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
    

#ifndef ACLUTIL_H
#define ACLUTIL_H
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <limits.h>
// ACL specific includes
#include "CL/opencl.h"
#include "aclutil.h"
#include "timer.h"

// Allocate and free memory aligned to value that's good for
// Altera OpenCL performance.
void *acl_aligned_malloc (size_t size);
void  acl_aligned_free (void *ptr);
unsigned char* load_file(const char* filename,size_t*size_ret);
cl_ulong get_max_mem_alloc_size(cl_context context, cl_command_queue queue, cl_device_id device);
#endif
