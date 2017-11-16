// Read/write test - Make sure host and kernels can access global memory
// $Header: $
#define V 16
#define REQD_WG_SIZE (1024 * 32)

// Pass arguments arg=1 and arg2=0 to get the intended lsu with ideal access
// pattern

__kernel void 
__attribute((reqd_work_group_size(REQD_WG_SIZE,1,1)))
__attribute((num_simd_work_items(V)))
mem_writestream (__global uint *dst, uint arg, uint arg2)
{
  int gid = get_global_id(0);
  dst[gid]=gid;
}

__kernel void 
__attribute((reqd_work_group_size(REQD_WG_SIZE,1,1)))
__attribute((num_simd_work_items(V)))
mem_readstream (__global uint *src, uint arg, uint arg2)
{
  int gid = get_global_id(0);
  int gvalue = src[gid];
  if(gvalue == 0 && arg == 3)
  	src[gid] = 2;  
}

__kernel void 
__attribute((reqd_work_group_size(REQD_WG_SIZE,1,1)))
__attribute((num_simd_work_items(V)))
mem_read_writestream (__global uint *src, uint arg, uint arg2)
{
  int gid = get_global_id(0) + arg2;
  int gvalue = src[gid];
  src[gid] = 2 + gvalue;
 }



__kernel void 
__attribute((reqd_work_group_size(REQD_WG_SIZE,1,1)))
nop ()
{
}

////////////////////////////////////////////////////
// Kernel launch test - pass a magic value from one kernel to the other
//
//   This test does not assume a working memory connection
///////////////////////////////////////////////////

channel uint kch;
#define MAGIC_VALUE 0xdead1234

__kernel void kernel_sender (uint arg)
{
  write_channel_altera(kch, arg);
}

__kernel void kernel_receiver ()
{
  uint val = 0;
  val = read_channel_altera(kch);

  // Hang if didn't get right value
  do {
  } while ( val != MAGIC_VALUE);
}

////////////////////////////////////////////////////
// Constant Cache Snoop Port test
///////////////////////////////////////////////////

__kernel void reorder_const (
    __global uint *dst,
    __global const uint *index,
    __constant uint *src)
{
    uint gID = get_global_id(0);
    uint ndx = index[gID];
    dst[gID] = src[ndx];
}
