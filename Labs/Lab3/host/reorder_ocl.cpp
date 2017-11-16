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
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <assert.h>
#include <limits.h>
// ACL specific includes
#include "CL/opencl.h"
#include "aclutil.h"

extern bool g_enable_notifications;
static size_t workSize;
static size_t globalSize; //must be evenly disible by workSize

// ACL runtime configuration
static cl_platform_id platform;
static cl_device_id device;
static cl_context context;
static cl_command_queue queue;
static cl_kernel kernel;
static cl_program program;
static cl_int status;

static cl_mem kernel_dum;
static cl_mem kernel_input;
static cl_mem kernel_index;
static cl_mem kernel_output;

int dum_size;

// free the resources allocated during initialization
static void freeResources() {
  if(kernel) 
	clReleaseKernel(kernel);  
  if(program) 
	clReleaseProgram(program);
  if(queue) 
	clReleaseCommandQueue(queue);
  if(context) 
	clReleaseContext(context);
  if(kernel_dum) 
	clReleaseMemObject(kernel_dum);
  if(kernel_input) 
	clReleaseMemObject(kernel_input);
  if(kernel_index) 
	clReleaseMemObject(kernel_index);
  if(kernel_output) 
	clReleaseMemObject(kernel_output);
}

static void dump_error(const char *str, cl_int status) {
  printf("%s\n", str);
  printf("Error code: %d\n", status);
  freeResources();
  exit(-1);
}


void ocl_device_init( cl_platform_id in_platform,
					  cl_device_id in_device,
					  cl_context in_context,
					  cl_command_queue in_queue, cl_program in_program)
{
  platform=in_platform;
  device=in_device;
  context=in_context;
  queue=in_queue;
  program = in_program;
}

void ocl_kernel_init( const char *kernel_name , const char *cl_file)
{
  // create the kernel
  kernel = clCreateKernel(program, kernel_name, &status);
  if(status != CL_SUCCESS) 
	dump_error("Failed clCreateKernel.", status);

  printf("Created Kernel %s ...\n", kernel_name);

}

void ocl_transfer_to_device(
	unsigned int *src,
	int n,
	cl_mem * mem) 
{

  assert(n);

  if(*mem) 
	clReleaseMemObject(*mem);
  if(kernel_dum) 
	clReleaseMemObject(kernel_dum);
  clFlush(queue);
  clFinish(queue);
  /************* Measuring maximum buffer size ******************** */
  cl_mem test = NULL;
  cl_ulong maxAlloc_size = 0;
  cl_ulong low = 1;
  cl_ulong high;

  status = clGetDeviceInfo(device, CL_DEVICE_MAX_MEM_ALLOC_SIZE, sizeof(maxAlloc_size), (void*)&maxAlloc_size, NULL);
  //printf("clGetDeviceInfo CL_DEVICE_MAX_MEM_ALLOC_SIZE = %llu bytes.\n", maxAlloc_size);
  high = maxAlloc_size;
  g_enable_notifications = false;
  while (low + 1 < high)
  {
	  cl_ulong mid = (low + high) / 2;
	  if (mid == 0)
	  {
		  printf("Error in findind maximum memory allocation size. \n");
		  return;
	  }
	  test = clCreateBuffer(context, CL_MEM_READ_WRITE, mid, NULL, &status);
	  clReleaseMemObject(test);
	  clFinish(queue);
	  if (status == CL_SUCCESS)
		  low = mid;
	  else
		  high = mid;
  }
  test = clCreateBuffer(context, CL_MEM_READ_WRITE, high, NULL, &status);
  clReleaseMemObject(test);
  if (status != CL_SUCCESS)
	  high = low;
  //printf("Do not ignore openCL notifications after this line. \n");
  g_enable_notifications = true;

  if (test)
	  clReleaseMemObject(test);
  clFinish(queue);
  maxAlloc_size = high;
  /************* Finished measuring maximum buffer size ******************** */

  if(dum_size > maxAlloc_size / 2){
		dum_size = maxAlloc_size / 2; 
	}
  cl_int dum_status;
  if(kernel_dum) 
	clReleaseMemObject(kernel_dum);
  kernel_dum = clCreateBuffer(context, CL_MEM_READ_ONLY, dum_size, NULL, &dum_status);
  if(dum_status != CL_SUCCESS) printf("Problem with creating dum buffer. \n");
  // "Randomly" assign a bank
  int bank = (src[0] & 0x800000) ? CL_MEM_BANK_2_ALTERA : 0;

  // create the input buffer
  *mem = clCreateBuffer(context, CL_MEM_READ_ONLY | bank, sizeof(unsigned int) * n, NULL, &status);
  if(status != CL_SUCCESS) dump_error("Failed clCreateBuffer for input.", status);
  //printf("Created buffer %10d bytes\n",sizeof(unsigned int) * n);

  // Write the input
  status = clEnqueueWriteBuffer(queue, *mem, CL_TRUE, 0, sizeof(unsigned int) * n, (void*)src, 0, NULL, NULL);
  if(status != CL_SUCCESS) dump_error("Failed to enqueue buffer write.", status);

#if 0
  // Clear array to better detect transfer errors
  unsigned int *dst = new unsigned int[n];
  for (int i=0; i<n; i++)
	dst[i]=0;

  // read the input
  status = clEnqueueReadBuffer(queue, *mem, CL_TRUE, 0, sizeof(unsigned int) * n, (void*)dst, 0, NULL, NULL);
  if(status != CL_SUCCESS) dump_error("Failed to enqueue buffer kernel_output.", status);

  // Make sure everything is done
  clFinish(queue);


  for (int i=0, errorcount=0; i<n && errorcount<15; i++)
	if (src[i]!=dst[i])
	{
	  printf("Host transfer error at %5i: %8x dst != %8x src, xor: %08x\n",i,dst[i],src[i],src[i]^dst[i]);
	  errorcount++;
	}

  delete [] dst;
#endif

}

void ocl_transfer_from_device(
	unsigned int *dst,
	int n,
	cl_mem *mem) 
{

  assert(n);
  assert(mem);

  status = clEnqueueReadBuffer(queue, *mem, CL_TRUE, 0, sizeof(unsigned int) * n, (void*)dst, 0, NULL, NULL);
  if(status != CL_SUCCESS) dump_error("Failed to enqueue buffer read.", status);

}

void ocl_kernel_run( int n, double *time) 
{

#ifdef ALTERA_CL
  globalSize=workSize=(n<256) ? n : (n/256)*256;
#else
  workSize=(n<256) ? n : 256;
  globalSize=(n/256)*256;
#endif

  assert(n);
  assert(workSize);
  assert(globalSize);

  // Create an output buffer here too
  if(kernel_output) 
	clReleaseMemObject(kernel_output);
  kernel_output = clCreateBuffer(context, CL_MEM_READ_WRITE, sizeof(unsigned int) * n, NULL, &status);
  if(status != CL_SUCCESS) dump_error("Failed clCreateBuffer for output.", status);
  //printf("Created output buffer %10d bytes\n",sizeof(unsigned int) * n);

  status  = clSetKernelArg(kernel, 2, sizeof(cl_mem), (void*)&kernel_input);
  status |= clSetKernelArg(kernel, 1, sizeof(cl_mem), (void*)&kernel_index);
  status |= clSetKernelArg(kernel, 0, sizeof(cl_mem), (void*)&kernel_output);
  if(status != CL_SUCCESS) dump_error("Failed Set args.", status);

  //printf("Launching the kernel with global size %d, workgroup size %d ...\n", globalSize,workSize);

  cl_event evt=NULL;

  // launch kernel
  status = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &globalSize, &workSize, 0, NULL, &evt);
  if (status != CL_SUCCESS) dump_error("Failed to launch kernel.", status);

  // Wait for kernel to complete
  clFinish(queue);


  // Output profile data
  if (time)
  {
	unsigned long long kernelEventStart;
	unsigned long long kernelEventEnd;

	clGetEventProfilingInfo(evt, CL_PROFILING_COMMAND_START, sizeof(unsigned long long), &kernelEventStart, NULL);
	clGetEventProfilingInfo(evt, CL_PROFILING_COMMAND_END, sizeof(unsigned long long), &kernelEventEnd, NULL);
	//printf("  Copy time: %llu ns ; Bytes : %u B ; Throughput: %f MB/s\n",
		//kernelEventEnd-kernelEventStart,
		//sizeof(unsigned int) * n,
		//((double)n * sizeof(unsigned int) * 1000)/(double)(kernelEventEnd-kernelEventStart));
	*time=(double)(kernelEventEnd-kernelEventStart);
  }

  clReleaseEvent(evt);
}

void ocl_modify_src( int offset, unsigned val ) 
{ 

  if(kernel_input) 
  {

	// Write the input
	status = clEnqueueWriteBuffer(queue, kernel_input, CL_TRUE, offset*sizeof(unsigned int), sizeof(unsigned int), (void*)&val, 0, NULL, NULL);
	if(status != CL_SUCCESS) dump_error("Failed to enqueue buffer write.", status);
  }

}

void ocl_transfer_src( unsigned int *src, int n) { ocl_transfer_to_device(src,n,&kernel_input); }
void ocl_transfer_dst( unsigned int *dst, int n ) { ocl_transfer_from_device(dst,n,&kernel_output); }
void ocl_transfer_index( unsigned int *index, int n) { ocl_transfer_to_device(index,n,&kernel_index); 
}
void ocl_transfer_dum( int n ) { dum_size=n; }

