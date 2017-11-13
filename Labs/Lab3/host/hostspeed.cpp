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
 * Measure PCIe bandwidth:
 *
 * Fastest: Max speed of any one Enqueue call
 * Slowest: Min speed of any one Enqueue call
 * Average: Sum of transfer times from Queued-End of each request divided
 * by total bytes
 * Total: Queue time of first Enqueue call to End time of last Enqueue call
 * divided by total bytes
 *
 * Final "Thoughput" value is average of max read and max write speeds.
 ********/

#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <time.h>
#include "aclutil.h"
#include "hostspeed_ocl.h"

// WARNING: host runs out of events if MAXNUMBYTES is much greater than
// MINNUMBYTES!!!
#define DEFAULT_MAXNUMBYTES (2097152*4)
#define DEFAULT_MINNUMBYTES (32768)


bool check_results(unsigned int * buf, unsigned int * output, int n)
{
  bool result=true;
  int prints=0;
  for (int j=0; j<n; j++)
    if (buf[j]!=output[j])
    {
      if (prints++ < 512)
        printf("Error! Mismatch at element %d: %8x != %8x, xor = %08x\n",
          j,buf[j],output[j], buf[j]^output[j]);
      result=false;
    }
  return result;
}

int hostspeed (cl_platform_id platform,
    cl_device_id device,
    cl_context context,
    cl_command_queue queue)
{
   srand ( time(NULL) );

   size_t maxbytes = DEFAULT_MAXNUMBYTES;
   size_t maxints = maxbytes/sizeof(int);


   size_t iterations=1;
   for (size_t i=maxbytes/DEFAULT_MINNUMBYTES; i>>1 ; i=i>>1)
     iterations++;

   struct speed *readspeed = new struct speed[iterations];
   struct speed *writespeed = new struct speed[iterations];

   bool result=true;

   unsigned int *buf = (unsigned int*) acl_aligned_malloc (maxints * sizeof(unsigned int));
   unsigned int *output = (unsigned int*) acl_aligned_malloc (maxints * sizeof(unsigned int));
  
   // Create sequence: 0 rand1 ~2 rand2 4 ...
   for (size_t j=0; j<maxints; j++)
     if (j%2==0)
       buf[j]=(j&2) ? ~j : j;
     else
       buf[j]=rand()*rand();

   hostspeed_ocl_device_init(platform, device, context, queue, maxbytes);

   size_t block_bytes=DEFAULT_MINNUMBYTES;

   // Warm up
   ocl_writespeed((char*)buf,block_bytes,maxbytes);
   ocl_readspeed((char*)output,block_bytes,maxbytes);

   for (size_t i=0; i<iterations; i++, block_bytes*=2)
   {
     printf("Transferring %d KBs in %d %d KB blocks ...\n",maxbytes/1024,maxbytes/block_bytes,block_bytes/1024);
     writespeed[i] = ocl_writespeed((char*)buf,block_bytes,maxbytes);
     readspeed[i] = ocl_readspeed((char*)output,block_bytes,maxbytes);
     result &= check_results(buf,output,maxints);
   }

   printf("\nPCIe Gen2.0 peak speed: 500MB/s/lane\n");

   printf("\nBlock_Size Avg Max Min End-End (MB/s)\n");

   float write_topspeed = 0;
   block_bytes=DEFAULT_MINNUMBYTES;
   printf("Writing %d KBs with block size (in bytes) below:\n",maxbytes/1024);
   for (size_t i=0; i<iterations; i++, block_bytes*=2)
   {
     printf("%8d %.2f %.2f %.2f %.2f\n", block_bytes, 
         writespeed[i].average,
         writespeed[i].fastest,
         writespeed[i].slowest,
         writespeed[i].total);

     if (writespeed[i].fastest > write_topspeed)
       write_topspeed = writespeed[i].fastest;
     if (writespeed[i].total > write_topspeed)
       write_topspeed = writespeed[i].total;
   }

   float read_topspeed = 0;
   block_bytes=DEFAULT_MINNUMBYTES;
   printf("Reading %d KBs with block size (in bytes) below:\n",maxbytes/1024);
   for (size_t i=0; i<iterations; i++, block_bytes*=2)
   {
     printf("%8d %.2f %.2f %.2f %.2f\n", block_bytes, 
         readspeed[i].average,
         readspeed[i].fastest,
         readspeed[i].slowest,
         readspeed[i].total);

     if (readspeed[i].fastest > read_topspeed)
       read_topspeed = readspeed[i].fastest;
     if (readspeed[i].total > read_topspeed)
       read_topspeed = readspeed[i].total;
   }

   printf("\nHost write top speed = %.2f MB/s\n",write_topspeed);
   printf("Host read top speed = %.2f MB/s\n",read_topspeed);
   //printf("Throughput = %.2f MB/s\n",(read_topspeed+write_topspeed)/2);
   printf("\n");
   printf("\nHOST-TO-MEMORY BANDWIDTH = %.0f MB/s\n",(read_topspeed+write_topspeed)/2);
   printf("\n");

   if (!result)
     printf("\nFAILURE!\n");

   acl_aligned_free (buf);
   acl_aligned_free (output);
   freeDeviceMemory(); 

   return (result) ? 0 : -1;
}
