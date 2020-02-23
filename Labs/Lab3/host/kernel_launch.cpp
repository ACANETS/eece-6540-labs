// (C) 1992-2016 Intel Corporation.                            
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
    

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// ACL specific includes
#include "CL/opencl.h"
#include "aclutil.h"
#include "timer.h"

#define MAGIC_VALUE 0xdead1234
#define NUM_KERNELS 2
static const char *kernel_name[] = { "kernel_sender", "kernel_receiver" };

// ACL runtime configuration
static cl_platform_id platform;
static cl_device_id device;
static cl_context context;
static cl_command_queue queue;
static cl_kernel kernel[NUM_KERNELS];
static cl_event event[NUM_KERNELS];
static cl_program program;
static cl_int status;

static void dump_error(const char *str, cl_int status) {
  printf("%s\n", str);
  printf("Error code: %d\n", status);
}

// free the resources allocated during initialization
static void freeResources() {
  for (int k = 0; k < NUM_KERNELS; k++)
  {
    if(kernel[k]) 
      clReleaseKernel(kernel[k]); 
    if(event[k])
  	clReleaseEvent(event[k]);
  }
}
int kernel_launch_test (
    cl_platform_id in_platform,
    cl_device_id in_device,
    cl_context in_context,
    cl_command_queue in_queue, cl_program in_program
    ) {

  platform = in_platform;
  device = in_device;
  context = in_context;
  queue = in_queue;
  program = in_program;
/*
  unsigned char* aocx; size_t aocx_len = 0;
  aocx = load_file("boardtest.aocx",&aocx_len); 
  if (aocx == NULL) 
  {
    printf("Error: Failed to find boardtest.aocx\n");
    exit(-1);
  }

  // create the program
  cl_int kernel_status;
  program = clCreateProgramWithBinary(context, 1, &device,
      &aocx_len, (const unsigned char **)&aocx, &kernel_status, &status);
  if(status != CL_SUCCESS) {
    dump_error("Failed clCreateProgramWithBinary.", status);
    freeResources();
    return 1;
  }

  // build the program
  status = clBuildProgram(program, 0, NULL, "",
      NULL, NULL);
  if(status != CL_SUCCESS) {
    dump_error("Failed clBuildProgram.",
        status);
    freeResources();
    return 1;
  }

  free(aocx);
*/

  for ( int k = 0; k < NUM_KERNELS; k++)
  {

    kernel[k] = clCreateKernel(program, kernel_name[k], &status);
    if(status != CL_SUCCESS) {
      dump_error("Failed clCreateKernel.", status);
      freeResources();
      return 1;
    }

    printf("Launching kernel %s ...\n",kernel_name[k]);

    if (strcmp(kernel_name[k],"kernel_sender") == 0)
    {
      unsigned int arg = MAGIC_VALUE;
      status = clSetKernelArg(kernel[k], 0, sizeof(unsigned int), &arg);
      if(status != CL_SUCCESS) {
        dump_error("Failed set arg 0.", status);
        return 1;
      }
    }

    size_t gsize = 1, lsize = 1;

    status = clEnqueueNDRangeKernel(queue, kernel[k], 1, NULL, &gsize, &lsize, 0, NULL, &event[k]);
    if (status != CL_SUCCESS) {
      dump_error("Failed to launch kernel.", status);
      freeResources();
      return 1;
    }

  }

  printf("  ... Waiting for sender\n");
  clWaitForEvents( 1, &event[0] );
  printf("  Sender sent the token to receiver\n");
  printf("  ... Waiting for receiver\n");
  clWaitForEvents( 1, &event[1] );

  // free the resources allocated
  freeResources();

  return 0;
}

