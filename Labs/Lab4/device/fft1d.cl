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
 * 'FFT_IN' and 'FFT_OUT' point to the input and output channels
 */

// Include source code for an engine that produces 8 points each step
#include "fft_8.cl" 

/* Attaching the attribute 'task' to the top level kernel to indicate 
 * that the host enqueues a task (a single work-item kernel)
 *
 */
kernel void fft1d(uint count) {
  /* The FFT engine requires a sliding window array for data reordering; data 
   * stored in this array is carried across loop iterations and shifted by one 
   * element every iteration; all loop dependencies derived from the uses of 
   * this array are simple transfers between adjacent array elements
   */
  float2 fft_delay_elements[N + PPC * (LOGN - 2)];

  /* This is the main loop. It runs 'count' back-to-back FFT transforms
   * In addition to the 'count * (N / 8)' iterations, it runs 'N / 8 - 1'
   * additional iterations to drain the last outputs 
   * (see comments attached to the FFT engine)
   *
   * The compiler leverages pipeline parallelism by overlapping the 
   * iterations of this loop - launching one iteration every clock cycle
   */

  for (unsigned i = 0; i < count * (N / PPC) + N / PPC - 1u; i++) {
    // Fetch the input data from the input channel
    float2x8 data;
    // Perform I/O transfers only when reading data in range
    if (i < count * (N / PPC)) {
      float8 data_in = read_channel_altera(FFT_IN);
      data.i0.x = data_in.s0;
      data.i0.y = 0;
      data.i1.x = data_in.s1;
      data.i1.y = 0;
      data.i2.x = data_in.s2;
      data.i2.y = 0;
      data.i3.x = data_in.s3;
      data.i3.y = 0;
      data.i4.x = data_in.s4;
      data.i4.y = 0;
      data.i5.x = data_in.s5;
      data.i5.y = 0;
      data.i6.x = data_in.s6;
      data.i6.y = 0;
      data.i7.x = data_in.s7;
      data.i7.y = 0;
    } else {
      data.i0 = data.i1 = data.i2 = data.i3 = 
                data.i4 = data.i5 = data.i6 = data.i7 = 0;
    }

    // Perform one step of the FFT engine
    data = fft_step(data, i % (N / PPC), fft_delay_elements, false, LOGN); 

    /* Store data back to memory. FFT engine outputs are delayed by 
     * N / 8 - 1 steps, hence gate writes accordingly
     */
    if (i >= N / PPC - 1) {
      float16 data_out;
      data_out[0]  = data.i0.x;
      data_out[1]  = data.i0.y;
      data_out[2]  = data.i1.x;
      data_out[3]  = data.i1.y;
      data_out[4]  = data.i2.x;
      data_out[5]  = data.i2.y;
      data_out[6]  = data.i3.x;
      data_out[7]  = data.i3.y;
      data_out[8]  = data.i4.x;
      data_out[9]  = data.i4.y;
      data_out[10] = data.i5.x;
      data_out[11] = data.i5.y;
      data_out[12] = data.i6.x;
      data_out[13] = data.i6.y;
      data_out[14] = data.i7.x;
      data_out[15] = data.i7.y;
      write_channel_altera(FFT_OUT, data_out);
    }
  }
}
