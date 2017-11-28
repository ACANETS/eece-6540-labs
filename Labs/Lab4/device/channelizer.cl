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

/* This kernel is based off of the fft1d design example.  The majority
 * of the code has been used unmodified and the reader is encouraged to
 * download the fft1d design example for an explanation of the implementation
 * details.  The modifications made tranform the kernel such that I/O is 
 * performed through channels instead of through global memory buffers.
 *
 * 'DATA_IN' and 'DATA_OUT' point to the input and output channels
 */

/* The parameters of our design:
 *   N - the size of the FFT to perform
 *   P - the scale factor of our polyphase filter structure (# of banks)
 *
 *   The constants are all defined as unsigned integers so that the compiler can
 *   take advantage of optimizations such as replacing multiplication or
 *   division by a power of 2 with a bit-shift.  Signed arithmetic imposes
 *   restrictions that would disable such optimizations from occuring.
 */
#define LOGN 12u
#define N (1u << LOGN)
#define P 8u
#define M (N*P)
#define PPC 8u // Points per cycle

// Channel declarations
channel float8  DATA_IN           __attribute__((depth(8)));
channel float8  FILTER_TO_REORDER __attribute__((depth(8)));
channel float8  REORDER_TO_FFT    __attribute__((depth(8)));
channel float16 DATA_OUT          __attribute__((depth(8)));

/* Stitch up the channels.  Each kernel expects a definition for its input and
 * output channels.
 */
#define FILTER_IN   DATA_IN
#define FILTER_OUT  FILTER_TO_REORDER
#define REORDER_IN  FILTER_TO_REORDER
#define REORDER_OUT REORDER_TO_FFT
#define FFT_IN      REORDER_TO_FFT 
#define FFT_OUT     DATA_OUT

/* The components of this example create a streaming pipeline designed to accept
 * input directly from a stream and feed output directly to an output channel.
 * The kernels below mimic those I/O streams by transferring data between global
 * memory and device channels.
 *
 * In order to demonstrate the throughput of the pipeline, the sample host
 * enqueues multiple iterations of the channelizer operation.  However we only
 * have M valid input samples and N valid output samples, so access the data
 * modulo M (or N) to keep from going out of bounds.
 */
kernel void data_in(global float8* data_in) {
  uint gid = get_global_id(0);
  float8 data = data_in[gid % (M/PPC)];
  write_channel_altera(DATA_IN, data);
}
kernel void data_out(global float8* data_out) {
  uint gid = get_global_id(0);
  float16 raw_data = read_channel_altera(DATA_OUT);
  float16 mult_data = raw_data * raw_data;
  float8 mag_data = mult_data.s02468ace + mult_data.s13579bdf;
  data_out[gid % (N/PPC)] = mag_data;
}

// Include the three datapath kernels
#include "fft1d.cl"
#include "reorder.cl"
#include "filter.cl"

