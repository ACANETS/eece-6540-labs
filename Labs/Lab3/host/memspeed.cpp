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
#ifdef __linux__
#define _popen popen
#define _pclose pclose
#endif


extern bool g_enable_notifications;
extern float Bandwidth_Nop;

static const size_t V = 16;
static const size_t wgSize = 1024 * 32;

static const size_t NUM_DIMMS = 8;
static const size_t NUM_KERNELS = 3;
static const char *kernel_name[] = {"mem_writestream", "mem_readstream", "mem_read_writestream"};

float bw[NUM_KERNELS][NUM_DIMMS];

// ACL runtime configuration
static cl_platform_id platform;
static cl_device_id device;
static cl_context context;
static cl_command_queue queue;
static cl_kernel kernel[NUM_KERNELS];
static cl_program program;
static cl_int status;

static cl_mem ddatain, ddataout;

// input and output vectors
static unsigned int *hdatain, *hdataout;

static void initializeVector(unsigned int * vector, size_t size) {
  for (unsigned int i = 0; i < size; ++i) {
	vector[i] = rand();
  }
}

static void dump_error(const char *str, cl_int status) {
  printf("%s\n", str);
  printf("Error code: %d\n", status);
}

// free the resources allocated during initialization
static void freeResources() {
  for (int k = 0; k < NUM_KERNELS; k++)
	if(kernel[k]) 
	  clReleaseKernel(kernel[k]); 
  if(ddatain) 
	clReleaseMemObject(ddatain);
  if(ddataout) 
	clReleaseMemObject(ddataout);
  if(hdatain) 
	acl_aligned_free(hdatain);
  if(hdataout) 
	acl_aligned_free(hdataout);
  clFinish(queue);  
}

int memspeed (
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

	size_t total_bytes_used;
	size_t vectorSize;
	// determine the size of bytes transferred
	cl_ulong maxAlloc_size  = get_max_mem_alloc_size(context, queue, device);
	if(maxAlloc_size == 0) return 1; 
	total_bytes_used = maxAlloc_size / 4;
	// check the sizes of the memory banks using board_spec
	bool f = true;
	char * s;
	int num = 0;
	FILE * board_sp = _popen ("aocl binedit boardtest.aocx print .acl.board_spec.xml", "r");
	if(!board_sp) {
		f = false;
		printf("Error in opening board spec. \n");
	}
	if(f) {
		while(feof(board_sp) == 0) {
			char w[100];
			
			fscanf(board_sp, "%s", &w);
			if(strcmp(w, "<interface") == 0) {
				while (!feof(board_sp)) {
					char i[100];
					fscanf(board_sp, "%s", &i);
					if(strncmp(i, "</global_mem>", 13)== 0)
						break;
					else if(strncmp(i, "size", 4)== 0) {
						//report the size of this memory bank
						num++;
						s = strtok(i, "=\"");
						s = strtok(NULL, "=\"");
						printf("Size of memory bank %d = %s B\n", num, s);
					} 
				}
				break;
			} 
		}
	}
	if(_pclose(board_sp) != 0)
		printf("Error in closing board_spec. \n");
	printf("\n");
	vectorSize = total_bytes_used / sizeof(unsigned);
	printf("Performing kernel transfers of %d MBs on the default global memory (address starting at 0) \n",sizeof(unsigned) * vectorSize / 1024 /1024);
	printf("  Note: This test assumes that design was compiled with --no-interleaving \n\n");

	// allocate and initialize the input vectors
	hdatain = (unsigned *)acl_aligned_malloc(sizeof(unsigned) * vectorSize);
	hdataout = (unsigned *)acl_aligned_malloc(sizeof(unsigned) * vectorSize);

	while (hdatain == NULL || hdataout == NULL) {
		vectorSize = vectorSize / 2;
		hdatain = (unsigned *)acl_aligned_malloc(sizeof(unsigned)* vectorSize);
		hdataout = (unsigned *)acl_aligned_malloc(sizeof(unsigned)* vectorSize);
	}

	initializeVector(hdatain, vectorSize);
	initializeVector(hdataout, vectorSize);
	for ( int k = 0; k < NUM_KERNELS; k++) {

	//printf("Creating kernel %d (%s)\n",k,kernel_name[k]);

	// create the kernel
		kernel[k] = clCreateKernel(program, kernel_name[k], &status);
		if(status != CL_SUCCESS) {
			dump_error("Failed clCreateKernel.", status);
			freeResources();
			return 1;
		}

		printf("Launching kernel %s ...\n",kernel_name[k]);
		for (int b = 0; b < NUM_DIMMS; b++) {
			cl_int memflags=0;

			switch(b) {
					case 0: memflags |= CL_MEM_BANK_1_ALTERA; break;
					case 1: memflags |= CL_MEM_BANK_2_ALTERA; break;
					case 2: memflags |= CL_MEM_BANK_3_ALTERA; break;
					case 3: memflags |= CL_MEM_BANK_4_ALTERA; break;
					case 4: memflags |= CL_MEM_BANK_5_ALTERA; break;
					case 5: memflags |= CL_MEM_BANK_6_ALTERA; break;
					case 6: memflags |= CL_MEM_BANK_7_ALTERA; break;
						//case 7: There is no CL_MEM_BANK_8_ALTERA!!!!
					default: memflags |= CL_MEM_BANK_1_ALTERA; break;
			}
			// create the input buffer
			ddatain = clCreateBuffer(context, CL_MEM_READ_WRITE | memflags, sizeof(unsigned) * vectorSize, NULL, &status);
			if(status != CL_SUCCESS) {
				dump_error("Failed clCreateBuffer.", status);
				freeResources();
				return 1;
			}

			clFinish(queue);	

			// set the arguments
			status = clSetKernelArg(kernel[k], 0, sizeof(cl_mem), (void*)&ddatain);
			if(status != CL_SUCCESS) {
				dump_error("Failed set arg 0.", status);
				return 1;
			}
			unsigned int arg=1;
			status = clSetKernelArg(kernel[k], 1, sizeof(unsigned int), &arg);
			unsigned int arg2=0;
			status |= clSetKernelArg(kernel[k], 2, sizeof(unsigned int), &arg2);
			if(status != CL_SUCCESS) {
				dump_error("Failed Set arg 1 and/or 2.", status);
				freeResources();
				return 1;
			}

			status = clEnqueueWriteBuffer(queue, ddatain, CL_FALSE, 0, sizeof(unsigned) * vectorSize, hdatain, 0, NULL, NULL);
			if(status != CL_SUCCESS) {
				dump_error("Failed to enqueue buffer kernelX.", status);
				freeResources();
				return 1;
			}
			clFinish(queue);

			// launch kernel
			//size_t gsize = vectorSize / V;
			size_t gsize = vectorSize;
			size_t lsize = wgSize;
			if (gsize%lsize != 0) lsize = 1;
			//printf("Kernel global size = %lu. \n", gsize);
			
			Timer t;
			t.start();
			status = clEnqueueNDRangeKernel(queue, kernel[k], 1, NULL, &gsize, &lsize, 0, NULL, NULL);
			if (status != CL_SUCCESS) {
				dump_error("Failed to launch kernel.", status);
				freeResources();
				return 1;
			}
			clFinish(queue);
			t.stop();
			float time = t.get_time_s();
			bw[k][b] = gsize  / (time * 1000000.0f) * sizeof(unsigned) * 2;
			if(k == 0 || k == 1)  bw[k][b] = gsize  / (time * 1000000.0f) * sizeof(unsigned);
			// read the input
			status = clEnqueueReadBuffer(queue, ddatain, CL_TRUE, 0, sizeof(unsigned) * vectorSize, hdatain, 0, NULL, NULL);
			if(status != CL_SUCCESS) {
				dump_error("Failed to enqueue buffer read.", status);
				freeResources();
				return 1;
			}
			clFinish(queue);
   
			if(ddatain) 
				clReleaseMemObject(ddatain);
			clFinish(queue);
		}
	}

	printf("\nSummarizing bandwidth in MB/s/bank for banks 1 to %d\n",NUM_DIMMS);
	float avg_bw=0.0;
	for ( int k = 0; k < NUM_KERNELS; k++) {
		for ( int b = 0; b < NUM_DIMMS; b++) {
		printf(" %.0f ",bw[k][b]);
		avg_bw += bw[k][b];
		}
		printf(" %s\n",kernel_name[k]);
	}
	avg_bw /= NUM_DIMMS * (NUM_KERNELS);

 
/*** Board bandwidth utlization ***/
// the global memory type used for analysis is the one starts at address 0

	bool p = true;
	char * Mb;
	float Max_bandwidth;
	int numOfInterfaces = 0;
	bool found = false;
	bool nameFound = false;
	bool memFound = false;
	char * name;
	char n[100];
	char *ad;
	FILE * board_spec = _popen ("aocl binedit boardtest.aocx print .acl.board_spec.xml", "r");
	if(!board_spec) {
		p = false;
		printf("Error in opening board spec. \n");
	}
	if(p) {
		while(feof(board_spec) == 0) {
			char w[100];
			char k[100];
			fscanf(board_spec, "%s", &w);
			if(!memFound && strcmp(w, "<global_mem") == 0) {
				memFound = true;
			}
			else if(!nameFound && memFound && strncmp(w, "name", 4) == 0) {
				strcpy(k, w);
				nameFound = true;
				name = strtok(k, "=\"");
				name = strtok(NULL, "=\"");
			}
			else if(memFound && strncmp(w, "max_bandwidth", 13) == 0) {
				Mb = strtok(w, "=\"" );
				Mb = strtok(NULL, "=\"");
				// count the number of interfaces
				while (!feof(board_spec)) {
					char i[100];
					fscanf(board_spec, "%s", &i);
					if(strncmp(i, "</global_mem>", 13)== 0)
						break;
					else if(strncmp(i, "<interface", 10)== 0)
						numOfInterfaces++;
					else if(strncmp(i, "address", 7) == 0 && !found)
					{
						ad = strtok(i, "=\"");
						ad = strtok(NULL, "=\"");
						if(strncmp(ad, "0x0", 3) == 0)
							found = true;
					}
				}
				if(found)
					break;
				numOfInterfaces = 0;
				memFound = false;
				nameFound = false;
			}
					  
	   }
		if(_pclose(board_spec) != 0)
			printf("Error in closing board_spec. \n");

	}

	if(found && numOfInterfaces != 0) {
		printf("\n");
		if(nameFound)
			printf("Name of the global memory type		:	 %s \n", name);
		else
			printf("Name of the global memory type not found in the board_spec. \n");
		printf("Number Of Interfaces 			:	 %d \n", numOfInterfaces);
		printf("Max Bandwidth (all memory interfaces)	:	 %s MB/s \n", Mb);
		Max_bandwidth = atof(Mb);
		Max_bandwidth = Max_bandwidth / numOfInterfaces;
		float utilization = (avg_bw/Max_bandwidth) * 100;
		printf("Max Bandwidth of 1 memory interface	:	 %.0f MB/s \n\n", Max_bandwidth); 
		printf("It is assumed that all memory interfaces have equal widths. \n\n");
		printf("BOARD BANDWIDTH UTILIZATION = %.2f% \n", utilization);
		if(utilization < 90)
			printf("Warning : Board bandwidth utilization is less than 90% \n");
	}
	else {
		printf("Warning: could not find global memory information in board spec.  \n");
	}
	printf("\n");
	printf("  Kernel mem bandwidth assuming ideal memory: %.0f MB/s\n", Bandwidth_Nop*V);
	printf("              * If this is lower than your board's peak memory\n");
	printf("              * bandwidth then your kernel's clock isn't fast enough\n");
	printf("              * to saturate memory\n");
	printf("              *   approx. fmax = %.0f\n",Bandwidth_Nop/sizeof(unsigned)/2.0);
	printf("\n");

	if(Bandwidth_Nop*V > Max_bandwidth)
		printf("Kernel mem bandwidth assuming ideal memory is greater than board's peak memory bandwidth. Success.\n");
	else
		printf("Warning : Kernel mem bandwidth assuming ideal memory is lower than board's peak memory bandwidth. Kernel's clock is not fast enough. \n");
	printf("\n");
	printf("\nKERNEL-TO-MEMORY BANDWIDTH = %.0f MB/s/bank\n",avg_bw);

  // free the resources allocated
	freeResources();

	return 0;
}


