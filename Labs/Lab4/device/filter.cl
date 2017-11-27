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

/* This kernel implements a polyphase filter bank which applies a 
 * Hanning-windowed sinc function shaped polyphase filter to the input signal.
 * The filter parameters are controlled by:
 *   N - the size of a single sample window
 *   P - the number of taps
 *   (consequently, N * P is the total length of the polyphase filter)
 * 
 * The implementation is adapted from:
 *   C. Harris and K. Haines, "A Mathematical Review of Polyphase Filterbank
 *   Implementations for Radio Astronomy", in Publications Astronomical Soc.
 *   Australia, 28, pp 317-322.
 *
 * 'FILTER_IN' and 'FILTER_OUT' point to the input and output channels
 */

// The table of filter coefficients
#include "filter_coefs.cl"

/* We have chosen to use a task instead of an ND range based kernel because it
 * enables us to easily describe the optimal shift-register based implementation
 * to the compiler and it simplifies the translation from the reference 
 * implementation to a parallel implementation.
 */
__kernel __attribute__((task))
void filter(uint count) {
  // The shift-register storing our samples
  float samples[M-N+PPC]; 

  // Iterate over all 'count' x N samples
  for (uint i=0; i<count*N/PPC; i++) {
    float coefs[PPC][P];
    float8 output;

    // Fetch a new set of samples from the input channel into a shift register
    float8 input = read_channel_altera(FILTER_IN);
    #pragma unroll
    for (uint j=0; j<(M-N); j++) {
      samples[j] = samples[j+PPC];
    }
    #pragma unroll
    for (uint j=0; j<PPC; j++) {
      samples[M-N+j] = input[j];
    }

    // Fetch the appropriate filter coefficients from constant tables
    uint coef_idx = i & (N/PPC-1);
    #pragma unroll
    for (uint j=0; j<P; j++) {
      coefs[0][j] = coefs_pt0[coef_idx*P+j];
      coefs[1][j] = coefs_pt1[coef_idx*P+j];
      coefs[2][j] = coefs_pt2[coef_idx*P+j];
      coefs[3][j] = coefs_pt3[coef_idx*P+j];
      coefs[4][j] = coefs_pt4[coef_idx*P+j];
      coefs[5][j] = coefs_pt5[coef_idx*P+j];
      coefs[6][j] = coefs_pt6[coef_idx*P+j];
      coefs[7][j] = coefs_pt7[coef_idx*P+j];
    }

    // Perform the filter coefficient multiplication, accumulating across the
    // polyphase taps appropriately
    #pragma unroll
    for (uint j=0; j<PPC; j++) {
      output[j]=0.0f;
      #pragma unroll
      for (uint k=0; k<P; k++) {
        output[j] += coefs[j][k] * samples[j+k*N];
      }
    }

    // Send the samples off to the next stage in the pipeline
    write_channel_altera(FILTER_OUT, output);
  }
}

