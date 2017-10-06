/* main.c
 *
 * show device list and info
 * reference:
 *  http://dhruba.name/2012/08/14/opencl-cookbook-listing-all-devices-and-their-critical-attributes/sho
 */

#include <stdio.h>
#include <stdlib.h>
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

int main() {

    int i, j;
    char* value;
    size_t valueSize;
    cl_uint platformCount;
    cl_platform_id* platforms;
    cl_uint deviceCount;
    cl_device_id* devices;
    cl_uint maxComputeUnits, maxAddressBits, clock_freq, maxDimen;
    cl_ulong globalMemSize, localMemSize;
    size_t maxWorkItemSizes[3], maxWorkGroupSize;

    // get all platforms
    clGetPlatformIDs(0, NULL, &platformCount);
    platforms = (cl_platform_id*) malloc(sizeof(cl_platform_id) * platformCount);
    clGetPlatformIDs(platformCount, platforms, NULL);

    for (i = 0; i < platformCount; i++) {

        // get all devices
        clGetDeviceIDs(platforms[i], CL_DEVICE_TYPE_ALL, 0, NULL, &deviceCount);
        devices = (cl_device_id*) malloc(sizeof(cl_device_id) * deviceCount);
        clGetDeviceIDs(platforms[i], CL_DEVICE_TYPE_ALL, deviceCount, devices, NULL);

        // for each device print critical attributes
        for (j = 0; j < deviceCount; j++) {

            // print device name
            clGetDeviceInfo(devices[j], CL_DEVICE_NAME, 0, NULL, &valueSize);
            value = (char*) malloc(valueSize);
            clGetDeviceInfo(devices[j], CL_DEVICE_NAME, valueSize, value, NULL);
            printf("%d. Device: %s\n", j+1, value);
            free(value);

            // print hardware device version
            clGetDeviceInfo(devices[j], CL_DEVICE_VERSION, 0, NULL, &valueSize);
            value = (char*) malloc(valueSize);
            clGetDeviceInfo(devices[j], CL_DEVICE_VERSION, valueSize, value, NULL);
            printf(" %d.%d Hardware version: %s\n", j+1, 1, value);
            free(value);

            // print software driver version
            clGetDeviceInfo(devices[j], CL_DRIVER_VERSION, 0, NULL, &valueSize);
            value = (char*) malloc(valueSize);
            clGetDeviceInfo(devices[j], CL_DRIVER_VERSION, valueSize, value, NULL);
            printf(" %d.%d Software version: %s\n", j+1, 2, value);
            free(value);

            // print c version supported by compiler for device
            clGetDeviceInfo(devices[j], CL_DEVICE_OPENCL_C_VERSION, 0, NULL, &valueSize);
            value = (char*) malloc(valueSize);
            clGetDeviceInfo(devices[j], CL_DEVICE_OPENCL_C_VERSION, valueSize, value, NULL);
            printf(" %d.%d OpenCL C version: %s\n", j+1, 3, value);
            free(value);

            // print parallel compute units
            clGetDeviceInfo(devices[j], CL_DEVICE_MAX_COMPUTE_UNITS,
                    sizeof(maxComputeUnits), &maxComputeUnits, NULL);
            printf(" %d.%d Parallel compute units: %d\n", j+1, 4, maxComputeUnits);

            // print address bits
            clGetDeviceInfo(devices[j], CL_DEVICE_ADDRESS_BITS,
                    sizeof(maxAddressBits), &maxAddressBits, NULL);
            printf(" %d.%d Address Bits: %d\n", j+1, 5, maxAddressBits);

            // print global memory size
            clGetDeviceInfo(devices[j], CL_DEVICE_GLOBAL_MEM_SIZE,
                    sizeof(globalMemSize), &globalMemSize, NULL);
            printf(" %d.%d Global Memory Size: %lu\n", j+1, 6, globalMemSize);

            // print local memory size
            clGetDeviceInfo(devices[j], CL_DEVICE_LOCAL_MEM_SIZE,
                    sizeof(localMemSize), &localMemSize, NULL);
            printf(" %d.%d Local Memory Size: %lu\n", j+1, 7, localMemSize);

            // print max clock frequency
            clGetDeviceInfo(devices[j], CL_DEVICE_MAX_CLOCK_FREQUENCY,
                    sizeof(clock_freq), &clock_freq, NULL);
            printf(" %d.%d Max Clock Frequency: %d MHz\n", j+1, 8, clock_freq);

            // print max work item dimensions
            clGetDeviceInfo(devices[j], CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS,
                    sizeof(maxDimen), &maxDimen, NULL);
            printf(" %d.%d Max Work Item Dimension: %d\n", j+1, 9, maxDimen);

            // print max work group size
            clGetDeviceInfo(devices[j], CL_DEVICE_MAX_WORK_GROUP_SIZE,
                    sizeof(maxWorkGroupSize), &maxWorkGroupSize, NULL);
            printf(" %d.%d Max Work Group Size: %lu\n", j+1, 10, maxWorkGroupSize);

            // print max work item sizes
            clGetDeviceInfo(devices[j], CL_DEVICE_MAX_WORK_ITEM_SIZES,
                    sizeof(size_t)*maxDimen, maxWorkItemSizes, NULL);
            printf(" %d.%d Max Work Item Sizes: [%lu,%lu,%lu] \n", j+1, 11, maxWorkItemSizes[0],maxWorkItemSizes[1],maxWorkItemSizes[2]);

        }

        free(devices);

    }

    free(platforms);
    return 0;

}

#ifdef AOCL                                                                     
// Altera OpenCL needs this callback function implemented in main.c             
// Free the resources allocated during initialization                           
void cleanup() {                                                                }                                                                               
#endif

