#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

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

#define NUM_SHORTS 8

int main()
{
    cl_uint platformCount;
    cl_platform_id* platforms;
    cl_device_id device_id;
    cl_uint ret_num_devices;
    cl_int ret;
    cl_context context = NULL;
    cl_command_queue command_queue = NULL;
    cl_program program = NULL;
    cl_kernel kernel = NULL;

    //cl_uint num_comp_units;
    //size_t global_size;
    //size_t local_size;
    cl_int i, j, check, temp, err;

    /* Data and buffers */
    unsigned short data[NUM_SHORTS];
    cl_mem data_buffer;

    FILE *fp;
    char fileName[] = "./mykernel.cl";
    char *source_str;
    size_t source_size;


    /* Initialize data */
    srand(time(NULL));
    for(i=0; i<NUM_SHORTS; i++) {
       data[i] = (unsigned short)i;
    }
    for(i=0; i<NUM_SHORTS-1; i++) {
       j = i + (rand() % (NUM_SHORTS-i));
       temp = data[i]; data[i] = data[j]; data[j] = temp;
    }

    /* Print input */
    printf("Input: \n");
    for(i=0; i<NUM_SHORTS; i++) {
       printf("data[%d]: %hu\n", i, data[i]);
    }


#ifdef __APPLE__
    /* Get Platform and Device Info */
    clGetPlatformIDs(1, NULL, &platformCount);
    platforms = (cl_platform_id*) malloc(sizeof(cl_platform_id) * platformCount);
    clGetPlatformIDs(platformCount, platforms, NULL);
    // we only use platform 0, even if there are more plantforms
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
   std::string binary_file = getBoardBinaryFile("mykernel", device_id);
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
    kernel = clCreateKernel(program, "radix_sort8", &ret);
    if (ret != CL_SUCCESS) {
      printf("Failed to create kernel.\n");
      exit(1);
    }

    /* Create buffer to hold sorted data */
    data_buffer = clCreateBuffer(context, CL_MEM_READ_WRITE |
          CL_MEM_COPY_HOST_PTR, sizeof(data), data, &err);
    if(err < 0) {
       perror("Couldn't create a buffer");
       exit(1);
    };

    /* Create kernel argument */
    err = clSetKernelArg(kernel, 0, sizeof(cl_mem), &data_buffer);
    if(err < 0) {
       printf("Couldn't set a kernel argument");
       exit(1);
    };


    /* Enqueue kernel */
    //ret = clEnqueueNDRangeKernel(command_queue, kernel, 2, NULL,
    //  globalws, localws, 0, NULL, NULL);
    /* clEnqueueTask() uses one work-item */
    ret = clEnqueueTask(command_queue, kernel, 0, NULL, NULL);
    if(ret < 0) {
       perror("Couldn't enqueue the kernel");
       printf("Error code: %d\n", ret);
       exit(1);
    }
    /* Read and print the result */
    err = clEnqueueReadBuffer(command_queue, data_buffer, CL_TRUE, 0,
       sizeof(data), &data, 0, NULL, NULL);
    if(err < 0) {
       perror("Couldn't read the buffer");
       exit(1);
    }

    /* Print output */
    printf("Output: \n");
    for(i=0; i<NUM_SHORTS; i++) {
       printf("data[%d]: %hu\n", i, data[i]);
    }

    /* Check the output and display test result */
    check = 1;
    for(i=0; i<NUM_SHORTS; i++) {
       if(data[i] != i) {
          check = 0;
          break;
       }
    }
    if(check)
       printf("The radix sort succeeded.\n");
    else
       printf("The radix sort failed.\n");

    clReleaseMemObject(data_buffer);
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
