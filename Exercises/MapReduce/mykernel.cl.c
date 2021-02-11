/***** GCL Generated File *********************/
/* Automatically generated file, do not edit! */
/**********************************************/

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <dispatch/dispatch.h>
#include <OpenCL/opencl.h>
#include <OpenCL/gcl_priv.h>
#include "mykernel.cl.h"

static void initBlocks(void);

// Initialize static data structures
static block_kernel_pair pair_map[1] = {
      { NULL, NULL }
};

static block_kernel_map bmap = { 0, 1, initBlocks, pair_map };

// Block function
void (^string_search_kernel)(const cl_ndrange *ndrange, cl_char16 pattern, cl_char* text, cl_int chars_per_item, size_t local_result, cl_int* global_result) =
^(const cl_ndrange *ndrange, cl_char16 pattern, cl_char* text, cl_int chars_per_item, size_t local_result, cl_int* global_result) {
  int err = 0;
  cl_kernel k = bmap.map[0].kernel;
  if (!k) {
    initBlocks();
    k = bmap.map[0].kernel;
  }
  if (!k)
    gcl_log_fatal("kernel string_search does not exist for device");
  kargs_struct kargs;
  gclCreateArgsAPPLE(k, &kargs);
  err |= gclSetKernelArgAPPLE(k, 0, sizeof(pattern), &pattern, &kargs);
  err |= gclSetKernelArgMemAPPLE(k, 1, text, &kargs);
  err |= gclSetKernelArgAPPLE(k, 2, sizeof(chars_per_item), &chars_per_item, &kargs);
  err |= gclSetKernelArgAPPLE(k, 3, local_result, NULL, &kargs);
  err |= gclSetKernelArgMemAPPLE(k, 4, global_result, &kargs);
  gcl_log_cl_fatal(err, "setting argument for string_search failed");
  err = gclExecKernelAPPLE(k, ndrange, &kargs);
  gcl_log_cl_fatal(err, "Executing string_search failed");
  gclDeleteArgsAPPLE(k, &kargs);
};

// Initialization functions
static void initBlocks(void) {
  const char* build_opts = "";
  static dispatch_once_t once;
  dispatch_once(&once,
    ^{ int err = gclBuildProgramBinaryAPPLE("mykernel.cl", "", &bmap, build_opts);
       if (!err) {
          assert(bmap.map[0].block_ptr == string_search_kernel && "mismatch block");
          bmap.map[0].kernel = clCreateKernel(bmap.program, "string_search", &err);
       }
     });
}

__attribute__((constructor))
static void RegisterMap(void) {
  gclRegisterBlockKernelMap(&bmap);
  bmap.map[0].block_ptr = string_search_kernel;
}

