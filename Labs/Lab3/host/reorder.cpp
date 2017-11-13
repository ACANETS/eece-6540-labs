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
#include <malloc.h>
#include <time.h>
#include "CL/opencl.h"
#include "aclutil.h"

#include "reorder_ocl.h"

/******************************* Profile stuff ********************************/

unsigned int my_rand()
{
  return (unsigned int)rand();
}

/******************************* Run OpenCL *******************************/

void randomize_src(unsigned int *src, int n)
{
   ocl_transfer_dum( (my_rand()%32)*1024 + my_rand());

   unsigned int prefix = my_rand()<<16;
   for (int j=0; j<n; j++)
     src[j]= prefix | j;
   ocl_transfer_src(src,n);
}

void randomize_index(unsigned int *index, int n1, int n2)
{
  ocl_transfer_dum( (my_rand()%32)*1024 + my_rand());

  for (int j=0; j<n2; j++)
    index[j]=((my_rand()<<16) + my_rand())%n1;
  ocl_transfer_index(index,n2);
}

int run(int n1, int n2, int iterations, double *time)
{
   int errors=0;
   double min_time = (double)(100000000000.0);
   double max_time = 0;
   double avg_time = 0;

   unsigned int *index = (unsigned int*)acl_aligned_malloc (n2 * sizeof(unsigned int));
   unsigned int *dst = (unsigned int*)acl_aligned_malloc (n2 * sizeof(unsigned int));

   // Initialize source array and download to FPGA
   unsigned int *src = (unsigned int*)acl_aligned_malloc (n1 * sizeof(unsigned int));
   if (index == NULL || dst == NULL || src == NULL)
   {
	   printf("Problem in allocating host memory \n");
	   if (src)
		   acl_aligned_free(src);
	   if (index)
		   acl_aligned_free(index);
	   if (dst)
		   acl_aligned_free(dst);
	   return 1;
   }
   randomize_src(src,n1);
   randomize_index(index,n1,n2);

   for (int i=0; i<iterations; i++)
   {
     int errors_this_iteration=0;
     double time;

     ocl_kernel_run ( n2, &time);

     // Aggregate time info
     //printf(" time = %g\n",time);
     if (time < min_time) min_time = time;
     if (time > max_time) max_time = time;
     avg_time += time;

     // Verify output is correct

     ocl_transfer_dst(dst,n2);

     for (int j=0; j<n2; j++)
       if (dst[j]!=src[index[j]])
       {
         if (errors_this_iteration++ == 30)
         {
           printf("    Giving up on comparison, too many errors\n");
           break;
         }
         else
           printf("  Mismatch iteration %d dst[%5i] = %8x ; src[%5i] = %8x\n",i,j,dst[j],index[j],src[index[j]]);
       }
     errors+=errors_this_iteration;

     // Now and then, modify the arrays
     if (i%200==1)
       randomize_index(index,n1,n2);
     else if (i%10==1)
       randomize_src(src,n1);
     else 
     {
       int ndx=((my_rand()<<16) + my_rand())%n1;
       unsigned int val=((my_rand()<<16) + my_rand());
       //printf("Modifying src with ndx %d (0x%x) and val %x\n",ndx,ndx,val);
       src[ndx]=val;
       ocl_modify_src(ndx,val);
     }
   }

   // Print profiling stats
   avg_time /= iterations;
   printf("  Min time: %11.0f\n",min_time);
   printf("  Max time: %11.0f\n",max_time);
   printf("  Avg time: %11.0f\n",avg_time);
   *time = avg_time;

#ifdef VERBOSE
   if (errors==0)
   {
     printf("SUCCESS!  First 10 elements:\n");
     for (int j=0; j<10; j++)
         printf("  %2i: %8x\n",j,dst[j]);
   }
#endif
   if (src)
	   acl_aligned_free(src);
   if (index)
	   acl_aligned_free(index);
   if (dst)
	   acl_aligned_free(dst);
   return errors;
}

/******************************* main *******************************/

int reorder (int DEFAULT_ARRAYSIZE, int DEFAULT_SUBARRAYSIZE, int DEFAULT_ITERATIONS,
             cl_platform_id in_platform,
             cl_device_id in_device,
             cl_context in_context,
             cl_command_queue in_queue, cl_program in_program)
{

   int iterations= DEFAULT_ITERATIONS;
   int n2= DEFAULT_SUBARRAYSIZE;
   int n1= DEFAULT_ARRAYSIZE;

   srand ( time(NULL) );


   ocl_device_init( in_platform, in_device, in_context, in_queue, in_program);

   //ocl_kernel_init ("reorder", "boardtest.cl");
   //double time;
   //int errors_nocache = run(n1, n2, iterations, &time);
   int errors_nocache = 0;

   ocl_kernel_init ("reorder_const", "boardtest.cl");
   double time_const;
   int errors_cache = run(n1, n2, iterations, &time_const);

   if (errors_cache || errors_nocache)
     printf("FAILED: Results were mismatched\n");
   //printf(" Cached errors = %d, Non-Cached errors = %d\n",errors_cache, errors_nocache);
   printf(" Finished %d iterations with %d errors\n",iterations,errors_cache);

   //double speedup = (time)/(time_const);
   //printf("Speedup = %g\n", speedup);

   return (errors_cache || errors_nocache) ? 1 : 0;
}

