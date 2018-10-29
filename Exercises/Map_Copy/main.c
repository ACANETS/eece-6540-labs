/* Example of OpenCL Memory Object Map and Copy */
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
    cl_context context = NULL;
    cl_command_queue command_queue = NULL;
    cl_program program = NULL;
    cl_kernel kernel = NULL;

    FILE *fp;
    char fileName[] = "./mykernel.cl";
    char *source_str;
    size_t source_size;

    /* Data and buffers */
    float data_one[100], data_two[100], result_array[100];
    cl_mem buffer_one, buffer_two;
    void* mapped_memory;
    cl_int i, j, err;

    /* Initialize arrays */
    for(i=0; i<100; i++) {
       data_one[i] = 1.0f*i;
       data_two[i] = -1.0f*i;
       result_array[i] = 0.0f;
    }

    /* Display original buffer */
    printf("Original buffer contents: \n");
    for(i=0; i<10; i++) {
       for(j=0; j<10; j++) {
          printf("%6.1f", result_array[j+i*10]);
       }
       printf("\n");
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
    kernel = clCreateKernel(program, "blank", &ret);
    if (ret != CL_SUCCESS) {
      printf("Failed to create kernel.\n");
      exit(1);
    }


    /* Create buffers */
    buffer_one = clCreateBuffer(context, CL_MEM_READ_WRITE |
          CL_MEM_COPY_HOST_PTR, sizeof(data_one), data_one, &err);
    if(err < 0) {
       perror("Couldn't create a buffer object");
       exit(1);
    }
    buffer_two = clCreateBuffer(context, CL_MEM_READ_WRITE |
          CL_MEM_COPY_HOST_PTR, sizeof(data_two), data_two, NULL);

    /* Set buffers as arguments to the kernel */
    err = clSetKernelArg(kernel, 0, sizeof(cl_mem), &buffer_one);
    err |= clSetKernelArg(kernel, 1, sizeof(cl_mem), &buffer_two);
    if(err < 0) {
       perror("Couldn't set the buffer as the kernel argument");
       exit(1);
    }

    /* Create a command queue */
    command_queue = clCreateCommandQueue(context, device_id, 0, &err);
    if(err < 0) {
       perror("Couldn't create a command queue");
       exit(1);
    };

    /* Enqueue kernel */
    err = clEnqueueTask(command_queue, kernel, 0, NULL, NULL);
    if(err < 0) {
       perror("Couldn't enqueue the kernel");
       exit(1);
    }

    /* Enqueue command to copy buffer one to buffer two */
    err = clEnqueueCopyBuffer(command_queue, buffer_one, buffer_two, 0, 0,
          sizeof(data_one), 0, NULL, NULL);
    if(err < 0) {
       perror("Couldn't perform the buffer copy");
       exit(1);
    }

    /* Enqueue command to map buffer two to host memory */
    mapped_memory = clEnqueueMapBuffer(command_queue, buffer_two, CL_TRUE,
          CL_MAP_READ, 0, sizeof(data_two), 0, NULL, NULL, &err);
    if(err < 0) {
       perror("Couldn't map the buffer to host memory");
       exit(1);
    }

    /* Transfer memory and unmap the buffer */
    memcpy(result_array, mapped_memory, sizeof(data_two));
    err = clEnqueueUnmapMemObject(command_queue, buffer_two, mapped_memory,
          0, NULL, NULL);
    if(err < 0) {
       perror("Couldn't unmap the buffer");
       exit(1);
    }

    /* Display updated buffer */
    for(i=0; i<10; i++) {
       for(j=0; j<10; j++) {
          printf("%6.1f", result_array[j+i*10]);
       }
       printf("\n");
    }

    /* Deallocate resources */
    clReleaseMemObject(buffer_one);
    clReleaseMemObject(buffer_two);
    clReleaseKernel(kernel);
    clReleaseCommandQueue(command_queue);
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
