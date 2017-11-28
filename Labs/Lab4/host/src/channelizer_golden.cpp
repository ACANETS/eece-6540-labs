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

/* Contains reference implementations of the polyphase filter bank and
 * 1D FFT algorithms.
 */
#define _USE_MATH_DEFINES
#include <math.h>
#include <stdlib.h>
#include <malloc.h>
#include "channelizer_golden.h"

// Helpers
static double sinc(double x);
static void fourier_stage(int lognr_points, double2 * data);

// Polyphase filter bank reference.
// Adapted from:
//   C. Harris and K. Haines, "A Mathematical Review of Polyphase Filterbank
//   Implementations for Radio Astronomy", in Publications Astronomical Soc.
//   Australia, 28, pp 317-322.
void filter_gold(float *datain, double2 *dataout, const int N, const int P) {
  const int M = N * P;
  double *coefs = new double[M];

  // Generate the filter coefficients
  for(int i=0; i<M; ++i){
    coefs[i] = sinc((i-M/2.0)/N);
    coefs[i] *= 0.5 - 0.5 * cos(2.0 * M_PI*i/M);
  }

  // Perform polyphase structure (and tack on a complex component for the FFT)
  for(int i=0; i<N; ++i) {
    dataout[i].x = 0.0;
    dataout[i].y = 0.0;
    for(int j=0; j<P; ++j) {
      dataout[i].x += coefs[j*N+i] * datain[j*N+i];
    }
  }

  delete [] coefs;
}

// Compute the magnitude-squared of the complex fft values
void magnitude(const int LOGN, double2 *h_fft, double *h_verify) {
  const int N = 1 << LOGN;
  for(int i=0; i<N; ++i)
    h_verify[i] = h_fft[i].x * h_fft[i].x + h_fft[i].y * h_fft[i].y;
  return;
}

// Reference Fourier transform.
// Adapted from the Altera 1D FFT example design.
void fourier_transform_gold(const int lognr_points, double2 *data) {
   const int nr_points = 1 << lognr_points;

   // Do a FT recursively
   fourier_stage(lognr_points, data);

   // Do the bit reversal
   double2 *temp = (double2 *)alloca(sizeof(double2) * nr_points);
   for (int i = 0; i < nr_points; i++) temp[i] = data[i];
   for (int i = 0; i < nr_points; i++) {
      int fwd = i;
      int bit_rev = 0;
      for (int j = 0; j < lognr_points; j++) {
         bit_rev <<= 1;
         bit_rev |= fwd & 1;
         fwd >>= 1;
      }
      data[i] = temp[bit_rev];
   }
}

// One stage of the Fourier transform
void fourier_stage(int lognr_points, double2 *data) {
   int nr_points = 1 << lognr_points;
   if (nr_points == 1) return;
   double2 *half1 = (double2 *)alloca(sizeof(double2) * nr_points / 2);
   double2 *half2 = (double2 *)alloca(sizeof(double2) * nr_points / 2);
   for (int i = 0; i < nr_points / 2; i++) {
      half1[i] = data[2 * i];
      half2[i] = data[2 * i + 1];
   }
   fourier_stage(lognr_points - 1, half1);
   fourier_stage(lognr_points - 1, half2);
   for (int i = 0; i < nr_points / 2; i++) {
      data[i].x = half1[i].x + cos (2 * M_PI * i / nr_points) * half2[i].x + sin (2 * M_PI * i / nr_points) * half2[i].y;
      data[i].y = half1[i].y - sin (2 * M_PI * i / nr_points) * half2[i].x + cos (2 * M_PI * i / nr_points) * half2[i].y;
      data[i + nr_points / 2].x = half1[i].x - cos (2 * M_PI * i / nr_points) * half2[i].x - sin (2 * M_PI * i / nr_points) * half2[i].y;
      data[i + nr_points / 2].y = half1[i].y + sin (2 * M_PI * i / nr_points) * half2[i].x - cos (2 * M_PI * i / nr_points) * half2[i].y;
   }
}

// The standard sinc function
//   sin(x) / x
double sinc(double x) {
  if(x == 0.0) {
    return 1.0;
  } else {
    return sin(M_PI * x) / (M_PI * x);
  }
}

