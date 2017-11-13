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
    

// timer.cpp
#include "timer.h"

#ifdef WINDOWS

Timer::Timer() {
  QueryPerformanceFrequency( &m_ticks_per_second );
}

void Timer::start() {
  QueryPerformanceCounter( &m_start_time );
}

void Timer::stop() {
  QueryPerformanceCounter( &m_stop_time );
}

float Timer::get_time_s() {
  LONGLONG delta = (m_stop_time.QuadPart - m_start_time.QuadPart);
  return (float)delta / (float)(m_ticks_per_second.QuadPart);
}

#else // LINUX
#include <stdio.h>
Timer::Timer() {
}

void Timer::start() {
  m_start_time = get_cur_time_s();
}

void Timer::stop() {
  m_stop_time = get_cur_time_s();
}

float Timer::get_time_s() {
  return (float)(m_stop_time - m_start_time);
}


double Timer::get_cur_time_s(void) {
  struct timespec a;
  const double NS_PER_S = 1000000000.0;
  clock_gettime (CLOCK_REALTIME, &a);
  return ((double)a.tv_nsec / NS_PER_S) + (double)(a.tv_sec);
}
#endif
