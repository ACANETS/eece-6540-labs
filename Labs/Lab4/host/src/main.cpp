// Copyright (C) 2013-2016 Altera Corporation, San Jose, California, USA. All rights reserved.
// Permission is hereby granted, free of charge, to any person obtaining a copy of this
// software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to
// whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
// 
// This agreement shall be governed in all respects by the laws of the State of California and
// by the laws of the United States of America.

///////////////////////////////////////////////////////////////////////////////////
// This OpenCL example implements a channelizer design on an Altera FPGA.  The
// set of kernels accept data from an input channel, stream it through
// a polyphase filter bank (to reduce spectral leakage) and a 4k-point 1D FFT
// transform on an Altera FPGA.
//
// The kernels are defined in the files under the 'device' directory.  The Altera 
// Offline Compiler tool ('aoc') compiles the kernel source into a 'channelizer.aocx' 
// file containing a hardware programming image for the FPGA.  The host program 
// provides the contents of the .aocx file to the clCreateProgramWithBinary OpenCL
// API for runtime programming of the FPGA.
//
// When compiling this application, ensure that the Altera SDK for OpenCL
// is properly installed.
///////////////////////////////////////////////////////////////////////////////////

#include <assert.h>
#include <stdio.h>
#define _USE_MATH_DEFINES
#include <math.h>
#include <cstring>
#include "CL/opencl.h"
#include "AOCLUtils/aocl_utils.h"
#include "channelizer_golden.h"
using namespace aocl_utils;

// The set of simultaneous kernels
enum KERNELS {
  K_READER,
  K_FILTER,
  K_REORDER,
  K_FFT,
  K_WRITER,
  K_NUM_KERNELS
};
static const char* kernel_names[K_NUM_KERNELS] =
{
  "data_in",
  "filter",
  "reorder",
  "fft1d",
  "data_out"
};

// ACL runtime configuration
static cl_platform_id platform = NULL;
static cl_device_id device = NULL;
static cl_context context = NULL;
static cl_command_queue queues[K_NUM_KERNELS];
static cl_kernel kernels[K_NUM_KERNELS];
static cl_program program = NULL;
static cl_int status = 0;

// Function prototypes
bool init();
void cleanup();
static void test_channelizer(const int LOGN, const int P, const int PPC, const int ITERS);
static void bitReverse(float* data, unsigned lognr_points);
static void fftShift(float* data, unsigned lognr_points);
static bool l2cmp(double *reference, float *fpga, int len);

// Host memory buffers
float *h_inData, *h_outData;
double *h_verify;
double2 *h_fft;

// Device memory buffers
cl_mem d_inData, d_outData;

// Entry point.
int main(int argc, char **argv) {
  Options options(argc, argv);

  // Parameters of our design - these must match up with the associated values in
  // the kernel
  const int LOGN = 12;
  const int P = 8;
  const int PPC = 8;

  int iters = P*58*1024;
  if(options.has("i")) {
    iters = options.get<int>("i");
  }

  if(iters < (P)) {
    printf("Error: iters must be more than %d.\n", P);
    return 1;
  }
  else if((iters % P) != 0) {
    printf("Error: iters must be a multiple of P (%d).\n", P);
    return 1;
  }

  printf("Number of iterations is set to %d\n",iters);

  // Derived constants
  const int N = (1 << LOGN);
  const int M = (N*P);


  // Flush stdout immediately
  setbuf(stdout, NULL);

  // Setup the context, create the device and kernels...
  if(!init()) {
    return false;
  }
  printf("Init complete!\n");

  // Allocate host memory
  h_inData = (float *)alignedMalloc(sizeof(float) * M);
  h_outData = (float *)alignedMalloc(sizeof(float) * N);
  h_verify = (double *)alignedMalloc(sizeof(double) * N);
  h_fft = (double2 *)alignedMalloc(sizeof(double2) * N);
  if (!(h_inData && h_outData && h_verify && h_fft)) {
    printf("ERROR: Couldn't create host buffers\n");
    return false;
  }

  // Test 4k point FFT transform
  test_channelizer(LOGN, P, PPC, iters);

  // Free the resources allocated
  cleanup();
  return 0;
}

// The test harness - generate some data, feed it through the FPGA kernel and
// compare against a functionally equivalent implementation implemented in
// channelizer_golden.cpp.
void test_channelizer(const int LOGN, const int P, const int PPC, const int ITERS) {
  const int N = (1 << LOGN);
  const int M = (N*P);

  printf("Launching FFT transform\n");

  // Initialize input and produce verification data
  for (int i = 0; i < M; i++) {
    h_inData[i] = (float)(cos( 128 * i * M_PI / (3*N)) 
                  + cos(2048 * i * M_PI / (3*N))
                  + 0.0001 * cos( 1765 * i * M_PI / (3*N)));
  }

  // Create device buffers - assign the buffers in different banks for more efficient
  // memory access 
  d_inData = clCreateBuffer(context, CL_MEM_READ_WRITE, sizeof(float) * M, NULL, &status);
  checkError(status, "Failed to allocate input device buffer\n");
  d_outData = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_BANK_2_ALTERA, sizeof(float) * N, NULL, &status);
  checkError(status, "Failed to allocate output device buffer\n");

  // Copy data from host to device
  status = clEnqueueWriteBuffer(queues[0], d_inData, CL_TRUE, 0, sizeof(float) * M, h_inData, 0, NULL, NULL);
  checkError(status, "Failed to copy data to device");

  // Set the kernel arguments
  // Read
  status = clSetKernelArg(kernels[K_READER], 0, sizeof(cl_mem), (void*)&d_inData);
  checkError(status, "Failed to set kernel_rd arg 0");
  // FFT
  cl_uint iters = ITERS;
  status = clSetKernelArg(kernels[K_FFT], 0, sizeof(cl_int), (void*)&iters);
  checkError(status, "Failed to set kernel_ff arg 0");
  // POLYPHASE
  status = clSetKernelArg(kernels[K_FILTER], 0, sizeof(cl_int), (void*)&iters);
  checkError(status, "Failed to set kernel_ff arg 0");
  // Write
  status = clSetKernelArg(kernels[K_WRITER], 0, sizeof(cl_mem), (void*)&d_outData);
  checkError(status, "Failed to set kernel_wr arg 0");

  // Get the timestamp to evaluate performance
  double time = getCurrentTimestamp();
  size_t window_size = N / PPC;
  size_t sample_size = window_size * ITERS;
  // READ
  status = clEnqueueNDRangeKernel(queues[K_READER], kernels[K_READER], 1, NULL, 
    &sample_size, NULL, 0, NULL, NULL);
  checkError(status, "Failed to launch kernel_read");
  // POLYPHASE
  status = clEnqueueTask(queues[K_FILTER], kernels[K_FILTER], 0, NULL, NULL);
  checkError(status, "Failed to launch kernel_read");
  // REORDER
  status = clEnqueueNDRangeKernel(queues[K_REORDER], kernels[K_REORDER], 1, NULL, 
    &sample_size, &window_size, 0, NULL, NULL);
  checkError(status, "Failed to launch kernel_reorder");
  // FFT
  status = clEnqueueTask(queues[K_FFT], kernels[K_FFT], 0, NULL, NULL);
  checkError(status, "Failed to launch kernel_fft");
  // Write
  status = clEnqueueNDRangeKernel(queues[K_WRITER], kernels[K_WRITER], 1, NULL, 
    &sample_size, NULL, 0, NULL, NULL);
  checkError(status, "Failed to launch kernel_write");

  // Wait for command queue to complete pending events
  for(int i=0; i<K_NUM_KERNELS; ++i) {
    status = clFinish(queues[i]);
    checkError(status, "Failed to finish (%d: %s)", i, kernel_names[i]);
  }

  // Record execution time
  time = getCurrentTimestamp() - time;

  // Copy results from device to host
  status = clEnqueueReadBuffer(queues[0], d_outData, CL_TRUE, 0, sizeof(float) * N, h_outData, 0, NULL, NULL);
  checkError(status, "Failed to copy data from device");

  printf("\tProcessing time = %.4fms\n", (float)(time * 1E3));
  double gpoints_per_sec = ((double)(ITERS) * N / time) * 1E-9;
  printf("\tThroughput = %.4f Gpoints / sec\n", gpoints_per_sec);

  // Compare with golden
  filter_gold(h_inData, h_fft, N, P);
  fourier_transform_gold(LOGN, h_fft);
  magnitude(LOGN, h_fft, h_verify);
  bool l2normtest = l2cmp(h_verify, h_outData, N);

  // Plot output
  FILE *file = fopen("data.dat", "w");
  assert(file);
  bitReverse(&h_outData[0], LOGN);
  fftShift(&h_outData[0], LOGN);
  for(int i = 0; i < N; ++i) {
    double magnitude = sqrt(h_outData[i]);
    fprintf(file, "%d\t%e\n", i, magnitude);
  }
  fclose(file);

  printf("\tL2-Norm check: %s\n", l2normtest ? "PASSED" : "FAILED");
}


/////// HELPER FUNCTIONS ///////
bool l2cmp(double *reference, float *fpga, int len) {
  const double epsilon = 1e-6;
  double error = 0.0;
  double ref = 0.0;
  for(int i=0; i<len; ++i) {
    double diff = reference[i] - fpga[i];
    error += diff * diff;
    ref += reference[i] * reference[i];
  }
  double normRef = sqrt(ref);
  if(fabs(ref) < 1e-7) {
    printf("Error: Reference l2-norm is 0\n");
    return false;
  }
  double normError = sqrt(error);
  error = normError / normRef;
  return (error < epsilon);
}

// Perform a bitreversal on the elements of data
void bitReverse(float* data, unsigned lognr_points) {
   const int nr_points = 1 << lognr_points;
   float *temp = (float *)alloca(sizeof(float) * nr_points);
   for (int i = 0; i < nr_points; i++) temp[i] = data[i];
   for (int i = 0; i < nr_points; i++) {
      int fwd = i;
      int bit_rev = 0;
      for (unsigned j = 0; j < lognr_points; j++) {
         bit_rev <<= 1;
         bit_rev |= fwd & 1;
         fwd >>= 1;
      }
      data[i] = temp[bit_rev];
   }
}

// Emulates the fftshift function in Matlab - shift the DC component of the
// spectrum to the middle element of data
void fftShift(float* data, unsigned lognr_points) {
   const int nr_points = 1 << lognr_points;
   float *temp = (float *)alloca(sizeof(float) * nr_points);
   for (int i = 0; i < nr_points/2; ++i) {
    float tmp = data[i];
    data[i] = data[i + nr_points/2];
    data[i+nr_points/2] = tmp;
   }
}

// Set up the context, device, kernels, and buffers...
bool init() {
  cl_int status;

  // Start everything at NULL to help identify errors
  for(int i = 0; i < K_NUM_KERNELS; ++i){
    kernels[i] = NULL;
    queues[i] = NULL;
  }

  // Locate files via. relative paths
  if(!setCwdToExeDir()) {
    return false;
  }

  // Get the OpenCL platform.
  platform = findPlatform("Intel(R) FPGA");
  if(platform == NULL) {
    printf("ERROR: Unable to find Altera OpenCL platform\n");
    return false;
  }

  // Query the available OpenCL devices and just use the first device if we find
  // more than one
  scoped_array<cl_device_id> devices;
  cl_uint num_devices;
  devices.reset(getDevices(platform, CL_DEVICE_TYPE_ALL, &num_devices));
  device = devices[0];

  // Create the context.
  context = clCreateContext(NULL, 1, &device, &oclContextCallback, NULL, &status);
  checkError(status, "Failed to create context");

  // Create the command queues
  for(int i=0; i<K_NUM_KERNELS; ++i) {
    queues[i] = clCreateCommandQueue(context, device, CL_QUEUE_PROFILING_ENABLE, &status);
    checkError(status, "Failed to create command queue (%d)", i);
  }

  // Create the program.
  std::string binary_file = getBoardBinaryFile("channelizer", device);
  printf("Using AOCX: %s\n\n", binary_file.c_str());
  program = createProgramFromBinary(context, binary_file.c_str(), &device, 1);

  // Build the program that was just created.
  status = clBuildProgram(program, 0, NULL, "", NULL, NULL);
  checkError(status, "Failed to build program");

  // Create the kernel - name passed in here must match kernel name in the
  // original CL file, that was compiled into an AOCX file using the AOC tool
  for(int i=0; i<K_NUM_KERNELS; ++i) {
    kernels[i] = clCreateKernel(program, kernel_names[i], &status);
    checkError(status, "Failed to create kernel (%d: %s)", i, kernel_names[i]);
  }

  return true;
}

// Free the resources allocated during initialization
void cleanup() {
  for(int i=0; i<K_NUM_KERNELS; ++i) {
    if(kernels[i]) 
      clReleaseKernel(kernels[i]);  
  }
  if(program) 
    clReleaseProgram(program);
  for(int i=0; i<K_NUM_KERNELS; ++i) {
    if(queues[i]) 
      clReleaseCommandQueue(queues[i]);
  }
  if(context) 
    clReleaseContext(context);
  if(h_inData)
    alignedFree(h_inData);
  if (h_outData)
    alignedFree(h_outData);
  if (h_verify)
    alignedFree(h_verify);
  if (h_fft)
    alignedFree(h_fft);
  if (d_inData)
    clReleaseMemObject(d_inData);
  if (d_outData) 
    clReleaseMemObject(d_outData);
}



