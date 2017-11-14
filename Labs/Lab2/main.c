// Courtney Ross
// Lab 2
// 11/14/2017
// main.c

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#ifdef __APPLE__
#include <OpenCL/opencl.h>
#else
#include <CL/cl.h>
#endif

#ifdef AOCL
#include "CL/opencl.h"
#include "AOCLUtils/aocl_utils.h"

using namespace aocl_utils;
void cleanup();
#endif

#define MAX_SOURCE_SIZE (0x100000)
#define DEVICE_NAME_LEN 128
static char dev_name[DEVICE_NAME_LEN];

 
int main()
{
    cl_uint platformCount;
    cl_platform_id* platforms;
    cl_device_id device_id;
    cl_uint ret_num_devices;
    cl_int ret;
    cl_context context 				= NULL;
    cl_command_queue command_queue 	= NULL;
    cl_program program 				= NULL;
    cl_kernel kernel 				= NULL;

    FILE *fp;
    char fileName[] = "./pi_over_4.cl";
    char *source_str;
    size_t source_size;

	/* Define number of work items used and number of calculations made in each work item */
    int work_items 	= 500;
	int max_terms	= 8;
	
	/* Define float for Pi so the value can be stored and output */
    double pi 		= 0.0f;   
    size_t globalws[1], localws[1]; 

#ifdef __APPLE__
    /* Get Platform and Device Info */
    clGetPlatformIDs(1, NULL, &platformCount);
    platforms = (cl_platform_id*) malloc(sizeof(cl_platform_id) * platformCount);
    clGetPlatformIDs(platformCount, platforms, NULL);
	
    // we only use platform 0, even if there are more platforms
    // Query the available OpenCL device.
    ret = clGetDeviceIDs(platforms[0], CL_DEVICE_TYPE_DEFAULT, 1, &device_id, &ret_num_devices);
    ret = clGetDeviceInfo(device_id, CL_DEVICE_NAME, DEVICE_NAME_LEN, dev_name, NULL);
    printf("device name= %s\n", dev_name);
#else

#ifdef AOCL  /* Altera FPGA */
    // get all platforms
    clGetPlatformIDs(0, NULL, &platformCount);
    platforms = (cl_platform_id*) malloc(sizeof(cl_platform_id) * platformCount);
	
    // Get the OpenCL platform.
    platforms[0] = findPlatform("Intel(R) FPGA");
	
    if(platforms[0] == NULL) {
      printf("ERROR: Unable to find Intel(R) FPGA OpenCL platform.\n");
      return false;
    }
	
    // Query the available OpenCL device.
    getDevices(platforms[0], CL_DEVICE_TYPE_ALL, &ret_num_devices);
    printf("Platform: %s\n", getPlatformName(platforms[0]).c_str());
    printf("Using one out of %d device(s)\n", ret_num_devices);
    ret = clGetDeviceIDs(platforms[0], CL_DEVICE_TYPE_DEFAULT, 1, &device_id, &ret_num_devices);
    printf("device name=  %s\n", getDeviceName(device_id).c_str());
	
#else
#error "unknown OpenCL SDK environment"
#endif

#endif

    /* Create OpenCL context */
    context = clCreateContext(NULL, 1, &device_id, NULL, NULL, &ret);

    /* Create Command Queue */
    command_queue = clCreateCommandQueue(context, device_id, 0, &ret);

#ifdef __APPLE__
    /* Load the source code containing the kernel*/
    fp = fopen(fileName, "r");
    if (!fp) {
      fprintf(stderr, "Failed to load kernel.\n");
      exit(1);
    }
    source_str = (char*)malloc(MAX_SOURCE_SIZE);
    source_size = fread(source_str, 1, MAX_SOURCE_SIZE, fp);
    fclose(fp);

    /* Create Kernel Program from the source */
    program = clCreateProgramWithSource(context, 1, (const char **)&source_str,
              (const size_t *)&source_size, &ret);
    if (ret != CL_SUCCESS) {
      printf("Failed to create program from source.\n");
      exit(1);
    }
#else

#ifdef AOCL  /* on FPGA we need to create kernel from binary */
   /* Create Kernel Program from the binary */
   std::string binary_file = getBoardBinaryFile("pi_over_4", device_id);
   printf("Using AOCX: %s\n", binary_file.c_str());
   program = createProgramFromBinary(context, binary_file.c_str(), &device_id, 1);
#else
#error "unknown OpenCL SDK environment"
#endif

#endif

    /* Build Kernel Program */
    ret = clBuildProgram(program, 1, &device_id, NULL, NULL, NULL);
    if (ret != CL_SUCCESS) {
      printf("Failed to build program.\n");
      exit(1);
    }

    /* Create OpenCL Kernel */
    kernel = clCreateKernel(program, "pi_over_4", &ret);
    if (ret != CL_SUCCESS) {
      printf("Failed to create kernel.\n");
      exit(1);
    }

    double *pi_div_4 = (double *)calloc (1, sizeof(double));
    printf ("%lf", pi_div_4[0]);
    printf("\n");

    /* allocate space for pi_div_4 on the device */
    cl_mem buffer_pi_div_4 = clCreateBuffer(context, CL_MEM_WRITE_ONLY,
            sizeof(double), NULL, &ret);

    // Set the kernel arguments
    clSetKernelArg(kernel, 0, sizeof(cl_mem), (void *)&buffer_pi_div_4);
    clSetKernelArg(kernel, 1, sizeof(cl_int), (void *)&work_items);
    clSetKernelArg(kernel, 2, sizeof(cl_int), (void *)&max_terms);	

    // Execute the kernel
     globalws[0] = work_items;
     localws[0] = 10;
    ret = clEnqueueNDRangeKernel(command_queue, kernel, 1, NULL, globalws, localws, 0, NULL, NULL);
   
    /* it is important to check the return value.
      for example, when enqueueNDRangeKernel may fail when Work group size
      does not divide evenly into global work size */
	  
    if (ret != CL_SUCCESS) {
      printf("Failed to enqueueNDRangeKernel.\n");
      exit(1);
    }

    /* Copy the output data back to the host */
    clEnqueueReadBuffer(command_queue, buffer_pi_div_4, CL_TRUE, 0, sizeof(double),
	(void *)pi_div_4, 0, NULL, NULL);

    // Check Results & Print Outputs
	printf ("Pi/4 =  %lf", pi_div_4[0]);
    printf("\n");

	// Multiply result of Pi/4 by 4 to get the value of Pi
    pi = pi_div_4[0] * 4;
	
	// Print value of Pi
    printf ("Pi = %lf ", pi);
    printf("\n");
	
	// Print additional info
	printf ("Number of work items used = %i ", work_items);
	printf ("Maximum number of terms used in each kernel = %i ", max_terms);

    // free resources for pi_div_4
    free(pi_div_4);

    clReleaseMemObject(buffer_pi_div_4);
    clReleaseCommandQueue(command_queue);
    clReleaseKernel(kernel);
    clReleaseProgram(program);
    clReleaseContext(context);

    return 0;
}

#ifdef AOCL
// Altera OpenCL needs this callback function implemented in main.c
// Free the resources allocated during initialization
void cleanup() {
}
#endif
