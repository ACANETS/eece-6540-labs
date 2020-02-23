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
    

/********
 * Testing host <-> dev read/writes
 *
 * - Testing all sizes from 0 to 1024.
 * - Doing non-aligned host SRC and non-aligned dev ptrs so
 *   - don't use DMA
 *   - exercise all the non-32bit-aligned logic in hal 
 *     (both with non-aligned to aligned and non-aligned to non-aligned)
 * - Check for over/under-writes
 * - Check PCIe Window changes by doing writes  and read to all available
 *   global memory. 
 *   - do that for all aligned/non-aligned host and dev ptrs (all combos)
 *
 ********/

#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <time.h>
#include <string.h>
#include <assert.h>
#include "aclutil.h"

#include "CL/opencl.h"


// Set to 1 to debug read/write correctness failures
#define DEBUG 0

// ACL runtime configuration
static cl_platform_id platform;
static cl_device_id device;
static cl_context context;
static cl_command_queue queue;
static cl_int status;


static void dump_error(const char *str, cl_int status) {
  printf("%s\n", str);
  printf("Error code: %d\n", status);
  exit(-1);
}

static void my_check_buf (char *src, char *dst, size_t size) {
  if (memcmp (src, dst, size) == 0) {
    return;
  } else {
    printf ("%d bytes read/write FAILED!\n", size);
    for (int i=0; i < size; i++) {
      if ( src[i] != dst[i])
        printf ("char #%d, src = %d, dst = %d\n", i, src[i], dst[i]);
    }
    assert (0);
  }
}

void test_rw (size_t dev_offset) {

  size_t maxbytes = 1024;
  size_t odd_maxbytes = maxbytes + 3;
  
  printf ("--- test_rw with device ptr offset %lu\n", dev_offset);
  
  // create the input buffer. +3 makes sure that DMA is not aligned
  cl_mem dev_buf = clCreateBuffer(context, CL_MEM_READ_WRITE, odd_maxbytes, NULL, &status);
  if(status != CL_SUCCESS) dump_error("Failed clCreateBuffer.", status);
  
  // allocate extra space around for overflow checks
  char invalid_host = -6;
  char invalid_read_back = -3;
  char *host_buf = (char*)acl_aligned_malloc (maxbytes + 10);
  char *host_buf_alloced = host_buf;
  for (int j = 0; j < maxbytes + 10; j++) {
    host_buf[j] = invalid_host;
  }
  // Make host ptr non-aligned. Will test un-aligned host ptr to un-aligned dev ptr
  host_buf += 5;
  
  char *read_back_buf = (char*)acl_aligned_malloc (maxbytes + 16);
  char *read_back_buf_alloced = read_back_buf;
  for (int j = 0; j < maxbytes + 16; j++) {
    read_back_buf[j] = (char) invalid_read_back;
  }
  // Read-back pointer is aligned. Testing reading from un-aligned dev to aligned host.
  read_back_buf += 8;
  
  
  if (DEBUG) printf ("host src buf = %p, host dst buf = %p\n", host_buf, read_back_buf);
  srand(0);
  
  // Non-DMA read/writes of all sizes upto 1024. 
  // (yes, testing 0 read/write as well!).
  for (int i = 1; i <= maxbytes; i++) {

    if (DEBUG) printf ("Read/write of %d bytes\n", i);  
    
    // host will have unique values for every write.
    for (int j = 0; j < i; j++) {
      host_buf[j] = (char)rand();
    }

    // Using +3 offset on aligned device pointer ensures that DMA is never used
    // (because the host ptr is aligned).
    status = clEnqueueWriteBuffer(queue, dev_buf, CL_TRUE, dev_offset, i, (void*)host_buf, 0, NULL, NULL);
    if(status != CL_SUCCESS) dump_error ("Failed to enqueue buffer write.", status);
   
  
    status = clEnqueueReadBuffer(queue, dev_buf, CL_TRUE, dev_offset, i, (void*)read_back_buf, 0, NULL, NULL);
    if(status != CL_SUCCESS) dump_error ("Failed to enqueue buffer.", status);
    
    // make sure read back what we wrote.
    if (DEBUG) printf ("%d, %d\n", read_back_buf[0], host_buf[0]);
    
    my_check_buf (host_buf, read_back_buf, i);
    
    // make sure bounds are ok
    assert (read_back_buf[-1] == invalid_read_back);
    assert (read_back_buf[-2] == invalid_read_back);
    assert (read_back_buf[-3] == invalid_read_back);
    assert (read_back_buf[-4] == invalid_read_back);
    assert (read_back_buf[-5] == invalid_read_back);
    
    assert (read_back_buf[i] == invalid_read_back);
    assert (read_back_buf[i+1] == invalid_read_back);
    assert (read_back_buf[i+2] == invalid_read_back);
    assert (read_back_buf[i+3] == invalid_read_back);
    assert (read_back_buf[i+4] == invalid_read_back);
  }

  clReleaseMemObject (dev_buf);
  acl_aligned_free(host_buf_alloced );
  acl_aligned_free(read_back_buf_alloced );
  // leak everything!
}


int rwtest (cl_platform_id i_platform,
    cl_device_id i_device,
    cl_context i_context,
    cl_command_queue i_queue)
{
  platform = i_platform;
  device = i_device;
  context = i_context;
  queue = i_queue;

  test_rw (3); // unaliged dev addr
  test_rw (0); // aligned dev addr

  // if did not die, everything is OK
  printf ("\nHOST READ-WRITE TEST PASSED!\n");  
  return 0;
}
