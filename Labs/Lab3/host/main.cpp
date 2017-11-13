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
#include <math.h>
#include <limits.h>
// ACL specific includes
#include "CL/opencl.h"
#include "aclutil.h"
#include "timer.h"
#ifdef __linux__
#define _popen popen
#define _pclose pclose
#endif

static const char* kernel_name = "nop";

static const size_t NUM_KERNELS = 10000;
static const size_t total_bytes_used = 1024 * 1024 * 256;

static const size_t V = 16;
static const size_t wgSize = 1024 * 32;
static const size_t vectorSize = (total_bytes_used / (sizeof(unsigned))) / 2;

int memspeed (
	cl_platform_id platform,
	cl_device_id device,
	cl_context context,
	cl_command_queue queue, cl_program program);
int memRW (
	cl_platform_id platform,
	cl_device_id device,
	cl_context context,
	cl_command_queue queue, cl_program program);

int reorder (int DEFAULT_ARRAYSIZE, int DEFAULT_SUBARRAYSIZE, int DEFAULT_ITERATIONS,
	cl_platform_id in_platform,
	cl_device_id in_device,
	cl_context in_context,
	cl_command_queue in_queue, cl_program program);
int hostspeed(
	cl_platform_id platform,
	cl_device_id device,
	cl_context context,
	cl_command_queue queue);
int rwtest(
	cl_platform_id platform,
	cl_device_id device,
	cl_context context,
	cl_command_queue queue);
int kernel_launch_test (
	cl_platform_id platform,
	cl_device_id device,
	cl_context context,
	cl_command_queue queue, cl_program program);
void ocl_notify(
	const char *errinfo, 
	const void *private_info, 
	size_t cb, 
	void *user_data);


// ACL runtime configuration
static cl_platform_id platform;
static cl_device_id * devices;
static cl_context context;
static cl_command_queue * queue;
static cl_int status;
static cl_program program;
static  cl_uint num_devices;

float Bandwidth_Nop;
//following added for kernel latency
static cl_kernel kernel;


// Set to false to temporarily disable printing of error notification callbacks
bool g_enable_notifications = true;
void ocl_notify(
	const char *errinfo, 
	const void *private_info, 
	size_t cb, 
	void *user_data) {
  if(g_enable_notifications) {
	printf("  OpenCL Notification Callback:");
	printf(" %s\n", errinfo);
  }
}

static void dump_error(const char *str, cl_int status) {
  printf("%s\n", str);
  printf("Error code: %d\n", status);
}


static void dump_init_error() {
  printf("Failed to initialize the device.  Please check the following:\n");
  printf("  1. The card is visible to your host operating system\n");
  printf("  2. There is a valid OpenCL design currently configured on the card\n");
  printf("  3. You've installed all necessary drivers\n");
  printf("  4. You've linked the host program with the correct libraries for your specific card\n");
};

// free the resources allocated during initialization
static void freeResources() {
for(int i = 0; i < num_devices; i++)
  if(queue[i]) 
	clReleaseCommandQueue(queue[i]);
  if(context) 
	clReleaseContext(context);
}

int main(int argc, char *argv[]) {
	cl_uint num_platforms;
	int test_to_run = 0; // This means run all tests
	int device_to_run = 0;
	bool test_all_devices = false;
	// Don't buffer stdout
	setbuf(stdout, NULL);

	//print usage information

	printf("Boardtest usage information\n");
	printf("Usage: boardtest_host [--device d] [--test t] \n	--device d: device number (0 - NUM_DEVICES-1) \n	--test t: test number (0 - 7) \n	(default is running all tests on all devices)\n"); 	
	// get the platform ID
	status = clGetPlatformIDs(1, &platform, &num_platforms);
	if(status != CL_SUCCESS) {
		dump_error("Failed clGetPlatformIDs.", status);
		dump_init_error();
		freeResources();
		return 1;
	}
	if(num_platforms != 1) {
		printf("Found %d platforms!\n", num_platforms);
		dump_init_error();
		freeResources();
		return 1;
	}
	status = clGetDeviceIDs(platform, CL_DEVICE_TYPE_ALL, 0, NULL, &num_devices);
	if(num_devices <= 0) {
		printf("Error: No device found on board. \n");
		return 1;
	}
	devices = (cl_device_id *)malloc(sizeof(cl_device_id)*num_devices);
	queue = (cl_command_queue *)malloc(sizeof(cl_command_queue)*num_devices);
	// get the device ID
	status = clGetDeviceIDs(platform, CL_DEVICE_TYPE_ALL, num_devices, devices, &num_devices);
	if(status != CL_SUCCESS) {
		dump_error("Failed clGetDeviceIDs.", status);
		dump_init_error();
		freeResources();
		return 1;
	}

	printf("Total number of devices = %d. \n", num_devices);
	bool incorrectArgs = false;
	//If no arguments provided - run on all devices and run all tests
	if(argc == 1) {
		test_to_run = 0;
		device_to_run = 0;
		test_all_devices = true;
	}
	else if(argc == 3) {
		// user is specifying either device or test to run
		if(strcmp(argv[1], "--device") == 0)
			device_to_run = atoi(argv[2]);
		else if(strcmp(argv[1], "--test") == 0)
			test_to_run = atoi(argv[2]);
		else
			incorrectArgs = true;
	}
	else if(argc == 5) {
		//user is specifing both device and the test to run
		//arguments could be in any order
		int c = 0; int b = 0;
		for(int n = 1; n < 4; n = n+2) {
			if(strcmp(argv[n], "--device") == 0) {
				device_to_run = atoi(argv[n+1]);
				b++;
			}
			else if(strcmp(argv[n], "--test") == 0) {
				test_to_run = atoi(argv[n+1]);
				c++;
			}
		}
		if(b != 1 || c != 1)
			incorrectArgs = true;
	}
	else
		incorrectArgs = true;
	// check validity of test and device argument values
	if(test_to_run < 0 || test_to_run > 6 || device_to_run < 0 || device_to_run >= num_devices)
		incorrectArgs = true;
	
	if(incorrectArgs == true) {
		printf("Error: Incorrect Arguments. \n");
		printf("Usage: boardtest_host [--device d] [--test t] \n	--device d: device number (0 - NUM_DEVICES-1) \n	--test t: test number (1 - 6) \n	(default is running all tests on all devices)\n");  
		return 1;
	}
	if(test_to_run > 0)
		printf("Running only test %d. \n",test_to_run);
	else
		printf("Running all tests. \n");
	if(test_all_devices == true)
		printf("Running on all devices. \n");
	else
		printf("Running only on device %d. \n", device_to_run);

	// create a context
	context = clCreateContext(0, num_devices, devices, &ocl_notify, NULL, &status);
	if(status != CL_SUCCESS) {
		dump_error("Failed clCreateContext.", status);
		freeResources();
		return 1;
	}
	// create a command queue
	for(int i = 0; i < num_devices; i++)
	{
		queue[i] = clCreateCommandQueue(context, devices[i], CL_QUEUE_PROFILING_ENABLE, &status);
		if(status != CL_SUCCESS) {
			dump_error("Failed clCreateCommandQueue.", status);
			freeResources();
			return 1;
		}
	}
	int temp = num_devices;
	if(!test_all_devices)
		num_devices = 1;
	const unsigned char **aocx = (const unsigned char **) malloc(num_devices * sizeof(unsigned char*));
	size_t *aocx_len = (size_t *) malloc(num_devices * sizeof(size_t));
	for(int i = 0; i < num_devices; i++) {
		aocx[i] = load_file("boardtest.aocx",&aocx_len[i]); 
		if (aocx[i] == NULL) {
			printf("Error: Failed to find boardtest.aocx\n");
			exit(-1);
		}
	}

	if(test_all_devices) {  
	// create the program for all devices
		cl_int kernel_status;
		program = clCreateProgramWithBinary(context, num_devices, devices,
	  aocx_len, aocx, &kernel_status, &status);
		if(status != CL_SUCCESS) {
			dump_error("Failed clCreateProgramWithBinary.", status);
			freeResources();
			return 1;
		}
		printf("Program object created for all devices. \n");

	// build the program for all devices
		status = clBuildProgram(program, num_devices, devices, "",NULL, NULL);
		if(status != CL_SUCCESS) {
			dump_error("Failed clBuildProgram.",    status);
			freeResources();
			return 1;
		}
		printf("Program built for all devices. \n"); 
		free(aocx);
		free(aocx_len);
	}
	else {
		// create the program for only specified device
		cl_int kernel_status;
		program = clCreateProgramWithBinary(context, num_devices, &devices[device_to_run],aocx_len, aocx, &kernel_status, &status);
		if(status != CL_SUCCESS) {
			dump_error("Failed clCreateProgramWithBinary.", status);
			freeResources();
			return 1;
		}
		printf("Program object created for device %d. \n", device_to_run);
		// build the program for all the devices the program is created for
		status = clBuildProgram(program, 0, NULL, "", NULL, NULL);
		if(status != CL_SUCCESS) {
			dump_error("Failed clBuildProgram.", status);
			freeResources();
			return 1;
		}
		printf("Program built for device %d. \n", device_to_run);
		free(aocx);
		free(aocx_len);
	}
	num_devices = temp;
	int ret = 0;
	cl_mem test = NULL;
	int d = device_to_run;
	for (d; d < num_devices; d++) {
		printf("\n");
		printf("*****************************************************************\n");
		printf("********************** TEST FOR DEVICE %d ***********************\n", d);
		printf("*****************************************************************\n");
		printf("\n");
		if ( test_to_run == 0 || test_to_run == 1) {

			printf("\n");
			printf("*****************************************************************\n");
			printf("*********************** Host Speed Test *************************\n");
			printf("*****************************************************************\n");
			printf("\n");

			ret |= hostspeed(platform,devices[d],context,queue[d]);

			printf("\n");
			printf("*****************************************************************\n");
			printf("********************* Host Read Write Test **********************\n");
			printf("*****************************************************************\n");
			printf("\n");

			int r = rwtest(platform,devices[d],context,queue[d]);
			clFinish(queue[d]);
			if(r!=0) {
				printf("Error: Host read write test failed. \n");
				freeResources();
				return 1;
			}
			ret |= r;
		}
		if ( test_to_run == 0 || test_to_run == 5 || test_to_run == 2 || test_to_run == 3 || test_to_run == 4 || test_to_run == 6 || test_to_run == 7) {
			printf("\n");
			printf("*****************************************************************\n");
			printf("*******************  Kernel Clock Frequency Test  ***************\n");
			printf("*****************************************************************\n");
			printf("\n");
			size_t gsize = vectorSize;
			size_t lsize = wgSize;
			Timer t;
			// create the kernel
			kernel = clCreateKernel(program, kernel_name, &status);
			if(status != CL_SUCCESS) {
				dump_error("Failed clCreateKernel.", status);
				freeResources();
				return 1;
			}

			t.start();
			status = clEnqueueNDRangeKernel(queue[d], kernel, 1, NULL, &gsize, &lsize, 0, NULL, NULL);
			if (status != CL_SUCCESS) {
				dump_error("Failed to launch kernel.", status);
				freeResources();
				return 1;
			}
			clFinish(queue[d]);
			clReleaseKernel(kernel);
			t.stop();
			float time = t.get_time_s();
			float bw;
			bw = gsize  / (time * 1000000.0f) * sizeof(unsigned int) * 2;
			Bandwidth_Nop = bw;	
			/*** Check to see if the measured clock frequency is equal to the quartus compiled fmax **/
			bool p = true;

			float MeasuredFreq = bw/sizeof(unsigned int)/2.0;
			FILE * quartus_report = _popen ("aocl binedit boardtest.aocx print .acl.quartus_report", "r");
			if(!quartus_report) {
				printf("incorrect parameters \n");
				p = false;
			}
			char word [80];
			float quartusFreq = 0;
			if(p) {
				while(feof(quartus_report) == 0) {
					char w[80]; 
					fscanf(quartus_report, "%s", &w);
					if(strcmp(w, "Actual") == 0)
						break;
				}
			if(!feof(quartus_report)) {
					fscanf(quartus_report, "%s", &word);
					fscanf(quartus_report, "%s", &word);
					fscanf(quartus_report, "%f", &quartusFreq);
			}
			if(_pclose(quartus_report) != 0) {
				printf("Error: could not run aocl binedit command. \n");
				freeResources();
				return 1;
			}
			printf("Measured Frequency 		= 	%f MHz. \n", MeasuredFreq);
			printf("Quartus Compiled Frequency 	= 	%f MHz. \n\n", quartusFreq);
			float PercentError = abs(quartusFreq - MeasuredFreq) / (quartusFreq) * 100;
			if(PercentError  < 2)
				printf("Measured Clock frequency is within 2 percent of quartus compiled frequency. \n");
			else {
				printf("Error: measured clock frequency not within 2 percent of quartus compiled frequency. \n");
				freeResources();
				return 1;
			}
	
		}
		printf("\n");
	}
	if ( test_to_run == 0 || test_to_run == 3) {
		printf("\n");
		printf("*****************************************************************\n");
		printf("********************* Kernel Launch Test ************************\n");
		printf("*****************************************************************\n");
		printf("\n");
	
		int r=kernel_launch_test (platform,devices[d],context,queue[d], program);
		// This will hang if it doesn't pass
		if (r==0)
			printf("\nKERNEL_LAUNCH_TEST PASSED\n\n");
		else {
			printf("Error: Kernel Launch Test Failed. \n");
			freeResources();
			return 1;
		}
		ret |= r;
		clFinish(queue[d]);

	}
	if ( test_to_run == 0 || test_to_run == 4) {
	
		printf("\n");
		printf("*****************************************************************\n");
		printf("********************  Kernel Latency   **************************\n");
		printf("*****************************************************************\n");
		printf("\n");
		printf("Creating kernel (%s)\n", kernel_name);

		// create the kernel
		kernel = clCreateKernel(program, kernel_name, &status);
		if(status != CL_SUCCESS) {
			dump_error("Failed clCreateKernel.", status);
			freeResources();
			return 1;
		}
		// launch kernel
		Timer t;
		t.start();

		for ( int l = 0; l < NUM_KERNELS; l++) {
			status = clEnqueueTask(queue[d], kernel, 0, NULL, NULL);
			if (status != CL_SUCCESS) {
				dump_error("Failed to launch kernel.", status);
				freeResources();
				return 1;
			}
  
		}
 
		clFinish(queue[d]);
		t.stop();
		float time = t.get_time_s();
		float bw = NUM_KERNELS * 1 / (time*1000.0f);
		printf("Processed %d kernels in %.4f ms\n", NUM_KERNELS, time*1000.0f);
		printf("Single kernel round trip time = %.4f us\n", time*1000000.0f/NUM_KERNELS);
		printf("Throughput = %.4f kernels/ms\n", bw);
		if(kernel)
			clReleaseKernel(kernel);
		printf("Kernel execution is complete.\n");

	}

	if ( test_to_run == 0 || test_to_run == 5) {
		printf("\n");
		printf("*****************************************************************\n");
		printf("*************  Kernel-to-Memory Read Write Test   ***************\n");
		printf("*****************************************************************\n");
		printf("\n");

		int r = memRW(platform,devices[d],context,queue[d],program);
		clFinish(queue[d]);
		if(r!=0)
		{
			printf("Error: kernel-memory read write test failed. \n");
			freeResources();
			return 1;
		}
		ret |= r;
	}


	if ( test_to_run == 0 || test_to_run == 6) {
		printf("\n");
		printf("*****************************************************************\n");
		printf("*****************  Kernel-to-Memory Bandwidth   *****************\n");
		printf("*****************************************************************\n");
		printf("\n");

		ret |= memspeed(platform,devices[d],context,queue[d],program);
		clFinish(queue[d]);
	}
	// Do not run on SoC boards, which do not have snoop ports
	#ifndef __arm__
	if ( test_to_run == 0 || test_to_run == 7) {
		printf("\n");
		printf("*****************************************************************\n");
		printf("*********************** Cache Snoop Test ************************\n");
		printf("*****************************************************************\n");
		printf("\n");
		int r=reorder(4096,4096,4000,platform,devices[d],context,queue[d], program);
		if (r==0)
			printf("\nSNOOP TEST PASSED\n");
		ret |= r;
	}
	#endif
	// free the resources allocated
	printf("\n");
	printf("*****************************************************************\n");
	printf("**************** TEST COMPLETED FOR DEVICE %d *******************\n", d);
	printf("*****************************************************************\n");
	printf("\n");

	if (test_all_devices == false)
		break;
	}
	if (ret == 0) 
		printf("\nBOARDTEST PASSED\n");
	freeResources();
	return ret;
}


