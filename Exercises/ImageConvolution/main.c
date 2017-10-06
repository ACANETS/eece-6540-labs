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

#include "utils.h"
#include "bmp-utils.h"
#include "gold.h"

static const char* inputImagePath = "./Images/cat.bmp";

static float gaussianBlurFilterFactor = 273.0f;
static float gaussianBlurFilter[25] = {
   1.0f,  4.0f,  7.0f,  4.0f, 1.0f,
   4.0f, 16.0f, 26.0f, 16.0f, 4.0f,
   7.0f, 26.0f, 41.0f, 26.0f, 7.0f,
   4.0f, 16.0f, 26.0f, 16.0f, 4.0f,
   1.0f,  4.0f,  7.0f,  4.0f, 1.0f};
static const int gaussianBlurFilterWidth = 5;

static float sharpenFilterFactor = 8.0f;
static float sharpenFilter[25] = {
    -1.0f, -1.0f, -1.0f, -1.0f, -1.0f,
    -1.0f,  2.0f,  2.0f,  2.0f, -1.0f,
    -1.0f,  2.0f,  8.0f,  2.0f, -1.0f,
    -1.0f,  2.0f,  2.0f,  2.0f, -1.0f,
    -1.0f, -1.0f, -1.0f, -1.0f, -1.0f};
static const int sharpenFilterWidth = 5;

static float edgeSharpenFilterFactor = 1.0f;
static float edgeSharpenFilter[9] = {
    1.0f,  1.0f, 1.0f,
    1.0f, -7.0f, 1.0f,
    1.0f,  1.0f, 1.0f};
static const int edgeSharpenFilterWidth = 3;

static float vertEdgeDetectFilterFactor = 1.0f;
static float vertEdgeDetectFilter[25] = {
     0,  0, -1.0f,  0,  0,
     0,  0, -1.0f,  0,  0,
     0,  0,  4.0f,  0,  0,
     0,  0, -1.0f,  0,  0,
     0,  0, -1.0f,  0,  0};
static const int vertEdgeDetectFilterWidth = 5;

static float embossFilterFactor = 1.0f;
static float embossFilter[9] = {
    2.0f,  0.0f,  0.0f,
    0.0f, -1.0f,  0.0f,
    0.0f,  0.0f, -1.0f};
static const int embossFilterWidth = 3;

enum filterList
{
   GAUSSIAN_BLUR,
   SHARPEN,
   EDGE_SHARPEN,
   VERT_EDGE_DETECT,
   EMBOSS,
   FILTER_LIST_SIZE
};
static const int filterSelection = VERT_EDGE_DETECT;
//static const int filterSelection = GAUSSIAN_BLUR;

#define MEM_SIZE (128)
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
    cl_mem filterBuffer, inputImage, outputImage;

    float *hInputImage;
    float *hOutputImage;

    int imageRows;
    int imageCols;
    int i;

    /* Set the filter here */
    cl_int filterWidth;
    float filterFactor;
    float *filter;

    FILE *fp;
    char fileName[] = "./mykernel.cl";
    char *source_str;
    size_t source_size;

    switch (filterSelection)
    {
      case GAUSSIAN_BLUR:
        filterWidth = gaussianBlurFilterWidth;
        filterFactor = gaussianBlurFilterFactor;
        filter = gaussianBlurFilter;
        break;
      case SHARPEN:
        filterWidth = sharpenFilterWidth;
        filterFactor = sharpenFilterFactor;
        filter = sharpenFilter;
        break;
      case EDGE_SHARPEN:
        filterWidth = edgeSharpenFilterWidth;
        filterFactor = edgeSharpenFilterFactor;
        filter = edgeSharpenFilter;
        break;
      case VERT_EDGE_DETECT:
        filterWidth = vertEdgeDetectFilterWidth;
        filterFactor = vertEdgeDetectFilterFactor;
        filter = vertEdgeDetectFilter;
        break;
      case EMBOSS:
        filterWidth = embossFilterWidth;
        filterFactor = embossFilterFactor;
        filter = embossFilter;
        break;
      default:
        printf("Invalid filter selection.\n");
        return 1;
    }

   for (int i = 0; i < filterWidth*filterWidth; i++)
   {
      filter[i] = filter[i]/filterFactor;
   }

   /* Read in the BMP image */
   hInputImage = readBmpFloat(inputImagePath, &imageRows, &imageCols);
   printf("imageRows=%d, imageCols=%d\n", imageRows, imageCols);
   printf("filterWidth=%d, \n", filterWidth);
   /* Allocate space for the output image */
   hOutputImage = (float *)malloc( imageRows*imageCols * sizeof(float) );
   for(i=0; i<imageRows*imageCols; i++)
     hOutputImage[i] = 1234.0;

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
    kernel = clCreateKernel(program, "convolution", &ret);
    if (ret != CL_SUCCESS) {
      printf("Failed to create kernel.\n");
      exit(1);
    }

    /* Create the images */
    cl_image_format imageFormat;
    imageFormat.image_channel_order = CL_R;
    imageFormat.image_channel_data_type = CL_FLOAT;

    inputImage = clCreateImage2D(context, CL_MEM_READ_ONLY, &imageFormat,
                    imageCols, imageRows, 0, NULL, &ret);
    if(inputImage == 0 || ret != CL_SUCCESS) {
      printf("clCreateImage2D error.\n");
    }
    outputImage = clCreateImage2D(context, CL_MEM_WRITE_ONLY, &imageFormat,
                    imageCols, imageRows, 0, NULL, &ret);
    if(inputImage == 0 || ret != CL_SUCCESS) {
      printf("clCreateImage2D error.\n");
    }

    /* Create a buffer for the filter */
    filterBuffer = clCreateBuffer(context, CL_MEM_READ_ONLY,
           filterWidth*filterWidth*sizeof(float), NULL, NULL);

    /* Copy the input data to the input image */
    size_t origin[3];
    origin[0] = 0;
    origin[1] = 0;
    origin[2] = 0;

    size_t region[3];
    region[0] = imageCols;
    region[1] = imageRows;
    region[2] = 1;
    ret = clEnqueueWriteImage (	command_queue,
 	                              inputImage,
 	                              CL_TRUE,
 	                              origin,
 	                              region,
 	                              0,
                                0,
                                hInputImage,
 	                              0,
 	                              NULL,
                                NULL);

    /* Copy the filter to the buffer */
    clEnqueueWriteBuffer(command_queue, filterBuffer, CL_TRUE, 0,
           filterWidth*filterWidth*sizeof(float), filter, 0, NULL, NULL);

    /* Create the sampler */
    cl_sampler sampler = clCreateSampler(context, CL_FALSE,
        CL_ADDRESS_CLAMP_TO_EDGE, CL_FILTER_NEAREST, NULL);

    /* Set the kernel arguments */
    clSetKernelArg(kernel, 0, sizeof(cl_mem), (void *)&inputImage);
    clSetKernelArg(kernel, 1, sizeof(cl_mem), (void *)&outputImage);
    clSetKernelArg(kernel, 2, sizeof(cl_mem), (void *)&filterBuffer);
    clSetKernelArg(kernel, 3, sizeof(cl_int), (void *)&filterWidth);
    clSetKernelArg(kernel, 4, sizeof(cl_sampler), (void *)&sampler);

    /* Execute the kernel */
    size_t globalws[2]={imageCols, imageRows};
    size_t localws[2] = {8, 8};
    ret = clEnqueueNDRangeKernel(command_queue, kernel, 2, NULL, globalws, localws, 0, NULL, NULL);
    if (ret != CL_SUCCESS) {
      printf("Failed to enqueue kernel.\n");
      exit(1);
    }

    /* Copy the output data back to the host */
    clEnqueueReadImage(command_queue, outputImage, CL_TRUE, origin, region, 0, 0,
         hOutputImage, 0, NULL, NULL);

    /* Save the output bmp */
    printf("Output image saved as: cat-filtered.bmp\n");
    writeBmpFloat(hOutputImage, "cat-filtered.bmp", imageRows, imageCols,
           inputImagePath);

    /* Verify result */
    float *refOutput = convolutionGoldFloat(hInputImage, imageRows, imageCols,
      filter, filterWidth);

    writeBmpFloat(refOutput, "cat-filtered-ref.bmp", imageRows, imageCols,
           inputImagePath);

    bool passed = true;
    for (i = 0; i < imageRows*imageCols; i++) {
      if (fabsf(refOutput[i]-hOutputImage[i]) > 0.001f) {
         //printf("%f %f\n", refOutput[i], hOutputImage[i]);
         passed = false;
      }
    }
    if (passed) {
      printf("Passed!\n");
    }
    else {
      printf("Failed!\n");
    }

    /* free host resources */
    free(refOutput);
    free(hInputImage);
    free(hOutputImage);

    /* free OpenCL resources */
    clReleaseMemObject(filterBuffer);
    clReleaseMemObject(inputImage);
    clReleaseMemObject(outputImage);
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
