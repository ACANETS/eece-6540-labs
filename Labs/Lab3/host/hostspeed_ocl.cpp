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

#include "hostspeed_ocl.h"
#include "aclutil.h"

// ACL specific includes
#include "CL/opencl.h"

static size_t workSize;
static size_t globalSize; //must be evenly disible by workSize

extern bool g_enable_notifications;

// ACL runtime configuration
static cl_platform_id platform;
static cl_device_id device;
static cl_context context;
static cl_command_queue queue;
static cl_kernel kernel;
static cl_program program;
static cl_int status;

static cl_mem kernel_input;

float ocl_get_exec_time_ns(cl_event evt);

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
  if(kernel_input) 
    clReleaseMemObject(kernel_input);
}


static void dump_error(const char *str, cl_int status) {
  printf("%s\n", str);
  printf("Error code: %d\n", status);
  freeResources();
  exit(-1);
}

void freeDeviceMemory() {
   if(kernel_input){
	clReleaseMemObject(kernel_input);
	}
}
void hostspeed_ocl_device_init( 
    cl_platform_id in_platform,
    cl_device_id in_device,
    cl_context in_context,
    cl_command_queue in_queue,
    size_t maxbytes )
{

  platform = in_platform;
  device = in_device;
  context = in_context;
  queue = in_queue;


  if (ocl_test_all_global_memory() != 0 )
    printf("Error: Global memory test failed\n");

  // create the input buffer
  kernel_input = clCreateBuffer(context, CL_MEM_READ_WRITE, maxbytes, NULL, &status);
  if(status != CL_SUCCESS) dump_error("Failed clCreateBuffer.", status);
}

size_t ocl_test_all_global_memory( )
{
  cl_mem mem;
  cl_event evt[2];
  cl_ulong max_buffer_size;
  cl_ulong max_alloc_size;
  const cl_ulong MB = 1024*1024;
  const cl_ulong MAX_HOST_CHUNK = 512 * MB;

  // 1. Get maximum size buffer
  status = clGetDeviceInfo(device, CL_DEVICE_GLOBAL_MEM_SIZE, sizeof(max_buffer_size), (void*)&max_buffer_size, NULL);
  status = clGetDeviceInfo(device,  CL_DEVICE_MAX_MEM_ALLOC_SIZE , sizeof(max_alloc_size), (void*)&max_alloc_size, NULL);

  printf("clGetDeviceInfo CL_DEVICE_GLOBAL_MEM_SIZE = %llu\n",max_buffer_size);
  printf("clGetDeviceInfo CL_DEVICE_MAX_MEM_ALLOC_SIZE = %llu\n",max_alloc_size);
  if (max_buffer_size > max_alloc_size)
    printf("Memory consumed for internal use = %llu\n",max_buffer_size-max_alloc_size);

  // 2. GetDeviceInfo may lie - so binary search to find true largest buffer
  cl_ulong low = 1;
  cl_ulong high = (max_buffer_size>max_alloc_size) ? max_buffer_size : max_alloc_size;
  status = CL_OUT_OF_RESOURCES;

  bool notifications_enabled = g_enable_notifications;
  g_enable_notifications = false;
  while ((low + 1 < high)){
    cl_ulong mid = (low+high) / 2;

    mem = clCreateBuffer(context, CL_MEM_READ_WRITE, mid, NULL, &status);
    clReleaseMemObject(mem);
    if (status==CL_SUCCESS)
      low = mid;
    else
      high = mid;
  }

  mem = clCreateBuffer(context, CL_MEM_READ_WRITE, high, NULL, &status);
  clReleaseMemObject(mem);
  if (status != CL_SUCCESS)
    high=low;
  else
    clReleaseMemObject(mem);

  g_enable_notifications = notifications_enabled;

  cl_ulong max_size = high;

  printf("Actual maximum buffer size = %llu bytes\n", max_size);

  // 3. Allocate the buffer (should consume all of memory)
  mem = clCreateBuffer(context, CL_MEM_READ_WRITE, max_size, NULL, &status);
  assert(status==CL_SUCCESS);

  // 4. Initialize memory with data = addr
  printf("Writing %llu MB to global memory ... ", max_size / MB);
  cl_ulong bytes_rem = max_size;
  cl_ulong offset = 0;
  double sum_time_ns = 0.0;
  cl_ulong *hostbuf = (cl_ulong*) acl_aligned_malloc(MAX_HOST_CHUNK);
  cl_ulong host_size = MAX_HOST_CHUNK;
  while (hostbuf == NULL) {
	  host_size = host_size / 2;
	  hostbuf = (cl_ulong *)acl_aligned_malloc(host_size);
  }
  while(bytes_rem > 0) {
    cl_ulong chunk = bytes_rem;
    if(chunk > host_size) chunk = host_size;
    for(cl_ulong i=0; i<chunk/sizeof(cl_ulong); ++i) {
      hostbuf[i] = offset + i;
    }
    status = clEnqueueWriteBuffer(queue, mem, CL_TRUE, offset, chunk,
      (void*)hostbuf, 0, NULL, &evt[0]);
    if(status != CL_SUCCESS) printf("failure to enque write buffer. \n");
    assert(status == CL_SUCCESS);

    double write_time_ns = ocl_get_exec_time_ns(evt[0]);;
    sum_time_ns += write_time_ns;
    clReleaseEvent(evt[0]);
    offset += chunk;
    bytes_rem -= chunk;
  }
  printf("%f MB/s\n",(float)max_size * 1000.0f / sum_time_ns);

  // 5. Read back all of memory and verify
  printf("Reading %llu bytes from global memory ... ", max_size);
  bytes_rem = max_size;
  offset = 0;
  sum_time_ns = 0.0;
  cl_ulong errors=0;
  while(bytes_rem > 0) {
    cl_ulong chunk = bytes_rem;
    if(chunk > host_size) chunk = host_size;
    status = clEnqueueReadBuffer(queue, mem, CL_TRUE, offset, chunk,
      (void*)hostbuf, 0, NULL, &evt[1]);
    assert(status == CL_SUCCESS);
    double read_time_ns = ocl_get_exec_time_ns(evt[1]);
    sum_time_ns += read_time_ns;

    // Verify
    for(cl_ulong i=0; i<chunk/sizeof(cl_ulong); ++i) {
      if(hostbuf[i] != (i + offset)) {
        ++errors;
        if (errors <= 32)
          printf("Verification failure at element %llu, expected %llx but read back %llx\n", i, i, hostbuf[i]);
        if (errors == 32)
          printf("Suppressing error output, counting # of errors ...\n");
        if (errors == 1)
          printf ("First failure at address %llx\n",i*(cl_ulong)sizeof(cl_ulong)+(max_buffer_size-max_size));
      }
    }

    clReleaseEvent(evt[1]);
    offset += chunk;
    bytes_rem -= chunk;
  }
  printf("%f MB/s\n",(float)max_size * 1000.0f / sum_time_ns);

  clReleaseMemObject(mem);
  
  printf("Verifying data ...\n", max_size);

  // 5. Do Verification
  if (errors == 0)
    printf ("Successfully wrote and readback %llu MB buffer\n", max_size/1024/1024);
  else
    printf ("Failed write/readback test with %llu errors\n",errors);
  printf("\n");

  acl_aligned_free(hostbuf);

  return errors;
}

float ocl_get_exec_time_ns(cl_event evt)
{
  cl_ulong kernelEventQueued;
  cl_ulong kernelEventSubmit;
  cl_ulong kernelEventStart;
  cl_ulong kernelEventEnd;
  clGetEventProfilingInfo(evt, CL_PROFILING_COMMAND_QUEUED, sizeof(unsigned long long), &kernelEventQueued, NULL);
  clGetEventProfilingInfo(evt, CL_PROFILING_COMMAND_SUBMIT, sizeof(unsigned long long), &kernelEventSubmit, NULL);
  clGetEventProfilingInfo(evt, CL_PROFILING_COMMAND_START, sizeof(unsigned long long), &kernelEventStart, NULL);
  clGetEventProfilingInfo(evt, CL_PROFILING_COMMAND_END, sizeof(unsigned long long), &kernelEventEnd, NULL);
  cl_ulong exectime_ns = kernelEventEnd-kernelEventQueued;
  return (float)exectime_ns;
}

// Get execution time between Queueing of first and ending of last
float ocl_get_exec_time2_ns(cl_event evt_first, cl_event evt_last)
{
  cl_ulong firstQueued;
  cl_ulong lastEnd;
  clGetEventProfilingInfo(evt_first, CL_PROFILING_COMMAND_QUEUED, sizeof(unsigned long long), &firstQueued, NULL);
  clGetEventProfilingInfo(evt_last, CL_PROFILING_COMMAND_END, sizeof(unsigned long long), &lastEnd, NULL);
  cl_ulong exectime_ns = lastEnd-firstQueued;
  return (float)exectime_ns;
}

struct speed ocl_readspeed(char * buf,size_t block_bytes,size_t bytes) 
{
  size_t num_xfers = bytes / block_bytes;

  assert(num_xfers>0);

  cl_event *evt = new cl_event[num_xfers];

  for (size_t i = 0 ; i < num_xfers; i++)
  {

    // read the input
    status = clEnqueueReadBuffer(queue, kernel_input, CL_TRUE, i*block_bytes, block_bytes, (void*)&buf[i*block_bytes], 0, NULL, &evt[i]);
    if(status != CL_SUCCESS) dump_error("Failed to enqueue buffer.", status);

  }

  // Make sure everything is done
  clFinish(queue);

  struct speed speed;
  speed.average = 0.0f;
  speed.fastest = 0.0f;
  speed.slowest = 10000000.0f;

  for (size_t i = 0 ; i < num_xfers; i++)
  {
    float time_ns = ocl_get_exec_time_ns(evt[i]);
    float speed_MBps = (float)block_bytes * 1000.0f / time_ns;

    if ( speed_MBps > speed.fastest)
      speed.fastest = speed_MBps;
    if ( speed_MBps < speed.slowest)
      speed.slowest = speed_MBps;

    speed.average += time_ns;
  }

  speed.average = (float)((float)bytes * 1000.0f / speed.average);
  speed.total = (float)((float)bytes * 1000.0f / 
      ocl_get_exec_time2_ns(evt[0],evt[num_xfers-1]));

  for (int i = 0 ; i < num_xfers; i++)
    clReleaseEvent(evt[i]);

  delete [] evt;
  return speed;
}

struct speed ocl_writespeed(char * buf,size_t block_bytes,size_t bytes)
{
  size_t num_xfers = bytes / block_bytes;

  assert(num_xfers>0);

  cl_event *evt = new cl_event[num_xfers];

  for (size_t i = 0 ; i < num_xfers; i++)
  {
    // Write the input
    status = clEnqueueWriteBuffer(queue, kernel_input, CL_TRUE, i*block_bytes, block_bytes, (void*)&buf[i*block_bytes], 0, NULL, &evt[i]);
    if(status != CL_SUCCESS) dump_error("Failed to enqueue buffer write.", status);
  }

  // Make sure everything is done
  clFinish(queue);

  struct speed speed;
  speed.average = 0.0f;
  speed.fastest = 0.0f;
  speed.slowest = 10000000.0f;

  for (size_t i = 0 ; i < num_xfers; i++)
  {
    float time_ns = ocl_get_exec_time_ns(evt[i]);
    float speed_MBps = (float)block_bytes * 1000.0f / time_ns;

    if ( speed_MBps > speed.fastest)
      speed.fastest = speed_MBps;
    if ( speed_MBps < speed.slowest)
      speed.slowest = speed_MBps;

    speed.average += time_ns;
  }

  speed.average = (float)((float)bytes * 1000.0f / speed.average);
  speed.total = (float)((float)bytes * 1000.0f / 
      ocl_get_exec_time2_ns(evt[0],evt[num_xfers-1]));

  for (int i = 0 ; i < num_xfers; i++)
    clReleaseEvent(evt[i]);

  delete [] evt;
  return speed;
}

