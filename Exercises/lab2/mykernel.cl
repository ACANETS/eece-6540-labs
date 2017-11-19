__kernel 
void pi_calculator(
    int iterations,
    __global float *global_result) 
{
    /* initialize local data */
    int tid = get_global_id(0);
    float sum = 0.0f;

    /* Make sure previous processing has completed */
    barrier(CLK_LOCAL_MEM_FENCE);
   
    for (int i=0; i<iterations; i++) 
    {
       if (i % 2 == 0)
          sum += 4.0f/((iterations*2*tid)+(2*i)+1);
       else
          sum += -4.0f/((iterations*2*tid)+(2*i)+1);
    }

    /* Make sure local processing has completed */
    barrier(CLK_GLOBAL_MEM_FENCE);

    /* Perform local reduction */
    global_result[tid] = sum;
}
