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

/* This kernel reads the matrix data and provides 8 parallel streams to the 
 * FFT engine. Each workgroup reads 8 matrix rows to local memory. Once this 
 * data has been buffered, the workgroup produces 8 streams from strided 
 * locations in local memory, according to the requirements of the FFT engine.
 *
 * 'REORDER_IN' and 'REORDER_OUT' point to the input and output channels
 */

// We pass into an 8 point channel so make sure there are at least 8 points
#if (LOGN < 3)
#error "Need at least 8 points for the reorder kernel"
#endif

/* Specify a required workgroup size so that the hardware is generated only for
 * that specific size.  This removes area overhead that would be introduced by
 * building generic hardware capable of handling any set of workgroup sizes.
 */
__attribute__((reqd_work_group_size((1 << (LOGN-3)), 1, 1)))
kernel void reorder() {
  float8 data;
  uint lid = get_local_id(0);

  // Local memory for storing one row
  local float8 buf8[N/PPC];
  // Cast to a scalar for easy access to individual elements
  local float* buf = (local float*)buf8;

  // Read 8 points into the local buffer
  buf8[lid] = read_channel_altera(REORDER_IN);
  barrier(CLK_LOCAL_MEM_FENCE);

  // Stream fetched data over 8 channels to the FFT engine
  data.s0 = buf[0 * N/PPC + lid];
  data.s1 = buf[4 * N/PPC + lid];
  data.s2 = buf[2 * N/PPC + lid];
  data.s3 = buf[6 * N/PPC + lid];
  data.s4 = buf[1 * N/PPC + lid];
  data.s5 = buf[5 * N/PPC + lid];
  data.s6 = buf[3 * N/PPC + lid];
  data.s7 = buf[7 * N/PPC + lid];
  write_channel_altera(REORDER_OUT, data);
}
