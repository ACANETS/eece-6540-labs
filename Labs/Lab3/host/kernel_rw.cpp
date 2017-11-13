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
#include <string>
#include <stdlib.h>
#include <math.h>
#include <limits.h>
#include <fstream>
#include <iostream>
using namespace std;
// ACL specific includes
#include "CL/opencl.h"
#include "aclutil.h"
#include "timer.h"
extern bool g_enable_notifications;

static const size_t V = 16;

static const size_t wgSize = 1024 * 32;
static size_t vectorSize;
static const size_t NUM_KERNELS = 1;
static const char *kernel_name[] = { "mem_read_writestream" };



// ACL runtime configuration
static cl_platform_id platform;
static cl_device_id device;
static cl_context context;
static cl_command_queue queue;
static cl_kernel kernel[NUM_KERNELS];
static cl_program program;
static cl_int status;

static cl_mem ddatain;

// input and output vectors
static unsigned int *hdatain, *hdataout;

static void initializeVector(unsigned int * vector, size_t size, unsigned int offset) {
	unsigned int i = 0;
	for (i; i < size; ++i) {
		vector[i] = offset + i;
	}
}

static void dump_error(const char *str, cl_int status) {
	printf("%s\n", str);
	printf("Error code: %d\n", status);
}

// free the resources allocated during initialization
static void freeResources() {
	for (int k = 0; k < NUM_KERNELS; k++)
		if (kernel[k])
			clReleaseKernel(kernel[k]);
	if (ddatain)
		clReleaseMemObject(ddatain);
	clFinish(queue);
}

int memRW(
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
	for (int k = 0; k < NUM_KERNELS; k++) {
		//printf("Creating kernel %d (%s)\n",k,kernel_name[k]);
		// create the kernel
		kernel[k] = clCreateKernel(program, kernel_name[k], &status);
		if (status != CL_SUCCESS) {
			dump_error("Failed clCreateKernel.", status);
			freeResources();
			return 1;
		}
		printf("Launching kernel %s ...\n", kernel_name[k]);
		cl_ulong maxAlloc_size = get_max_mem_alloc_size(context, queue, device);
		if (maxAlloc_size == 0) return 1;
		vectorSize = maxAlloc_size / sizeof(unsigned);
		size_t vectorSize_bytes = vectorSize * sizeof(unsigned);
		// create the input buffer
		ddatain = clCreateBuffer(context, CL_MEM_READ_WRITE, vectorSize_bytes, NULL, &status);
		if (status != CL_SUCCESS) {
			dump_error("Failed clCreateBuffer.", status);
			freeResources();
			return 1;
		}
		clFinish(queue);
		printf("Created kernel buffer. \n");
		// allocate and initialize the input vectors
		size_t host_vectorSize_bytes = vectorSize_bytes / 2;
		size_t host_vectorSize = host_vectorSize_bytes / sizeof(unsigned);
		hdatain = (unsigned *)acl_aligned_malloc(host_vectorSize * sizeof(unsigned));
		hdataout = (unsigned *)acl_aligned_malloc(host_vectorSize * sizeof(unsigned));
		while (hdatain == NULL || hdataout == NULL) {
			host_vectorSize = host_vectorSize / 2;
			hdatain = (unsigned *)acl_aligned_malloc(host_vectorSize * sizeof(unsigned));
			hdataout = (unsigned *)acl_aligned_malloc(host_vectorSize * sizeof(unsigned));
		}
		host_vectorSize_bytes = host_vectorSize * sizeof(unsigned);
		cl_ulong offset_bytes = 0;
		cl_ulong bytes_rem = vectorSize_bytes;
		while (bytes_rem > 0)
		{
			cl_ulong chunk = bytes_rem;
			if (chunk > host_vectorSize_bytes)
				chunk = host_vectorSize_bytes;
			host_vectorSize = chunk / sizeof(unsigned);
			unsigned int offset = offset_bytes / sizeof(unsigned);
			initializeVector(hdatain, host_vectorSize, offset);
			initializeVector(hdataout, host_vectorSize, offset);
			printf("Finished initializing host vectors.  \n");
			// set the arguments
			status = clEnqueueWriteBuffer(queue, ddatain, CL_TRUE, offset_bytes, chunk, hdatain, 0, NULL, NULL);
			if (status != CL_SUCCESS) {
				dump_error("Failed to enqueue buffer kernelX.", status);
				freeResources();
				return 1;
			}
			clFinish(queue);
			printf("Finished writing to buffers. \n");
			offset_bytes += chunk;
			bytes_rem -= chunk;
		}
		clFinish(queue);
		status = clSetKernelArg(kernel[k], 0, sizeof(cl_mem), (void*)&ddatain);
		if (status != CL_SUCCESS) {
			dump_error("Failed set arg 0.", status);
			return 1;
		}
		unsigned int arg = 1;
		status = clSetKernelArg(kernel[k], 1, sizeof(unsigned int), &arg);
		unsigned int arg2 = 0;
		status |= clSetKernelArg(kernel[k], 2, sizeof(unsigned int), &arg2);
		if (status != CL_SUCCESS) {
			dump_error("Failed Set arg 1 and/or 2.", status);
			freeResources();
			return 1;
		}
		printf("Finished setting kernel args. \n");
		// launch kernel
		size_t gsize = vectorSize;
		//printf("Kernel global size = %lu. \n", gsize);
		size_t lsize = wgSize;
		if (gsize%lsize != 0) lsize = 1;
		status = clEnqueueNDRangeKernel(queue, kernel[k], 1, NULL, &gsize, &lsize, 0, NULL, NULL);
		if (status != CL_SUCCESS) {
			dump_error("Failed to launch kernel.", status);
			freeResources();
			return 1;
		}
		clFinish(queue);
		printf("Kernel executed. \n");
		bytes_rem = vectorSize_bytes;
		offset_bytes = 0;
		while (bytes_rem > 0)
		{
			cl_ulong chunk = bytes_rem;
			if (chunk > host_vectorSize_bytes)
				chunk = host_vectorSize_bytes;
			host_vectorSize = chunk / sizeof(unsigned);
			int offset = offset_bytes / sizeof(unsigned);
			status = clEnqueueReadBuffer(queue, ddatain, CL_TRUE, offset_bytes, chunk, hdataout, 0, NULL, NULL);
			if (status != CL_SUCCESS) {
				dump_error("Failed to enqueue buffer read.", status);
				freeResources();
				return 1;
			}
			clFinish(queue);
			printf("Finished Reading buffer. \n");
			// verify the output - Read and write stream kernel updates the buffer ddatain (src)
			// - src[gid] = oldvalue + 2,       
			for (unsigned int i = 0; i < host_vectorSize; i++) {
				if (hdataout[i] != offset + i + 2) {
					printf("Verification failed %d: %d != %d \n",
						i, hdataout[i], offset + i + 2);
					if (hdatain)
						acl_aligned_free(hdatain);
					if (hdataout)
						acl_aligned_free(hdataout);
					freeResources();
					return 1;
				}
			}
			offset_bytes += chunk;
			bytes_rem -= chunk;
		}
		if (hdatain)
			acl_aligned_free(hdatain);
		if (hdataout)
			acl_aligned_free(hdataout);
		if (ddatain)
			clReleaseMemObject(ddatain);
		clFinish(queue);
	}

	printf("KERNEL MEMORY READ WRITE TEST PASSED. \n");
	// free the resources allocated
	freeResources();
	return 0;
}





