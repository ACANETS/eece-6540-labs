// Courtney Ross
// Lab 2
// 11/14/2017
// pi_over_4.cl

__kernel void pi_over_4(
    __global float *sum_out,
    int work_items,
	int max_terms) 
{

// -- Define local variables --------------------------------------------
__local float sum_local[1]; 
__local int mod_val;

// -- Define global term index and float for sum of terms ---------------
    int term_index 	= get_global_id (0);
    float sum 		= 0.0f; 
	
// -- Make sure previous processing has completed ------------------------
	barrier(CLK_LOCAL_MEM_FENCE);
	
// -- Using a loop, index through terms using max terms value and work- -- 
// -- items to correctly calculate terms in pi/4--------------------------

	for (int i = 0; i < max_terms - 1; i++) {
		mod_val = fmod((int)(i), (int)2);
		
		// using modulo base 2 operations, determine the sign required ----
		// to complete the term for the calculation. If mod = 0, no -------
		// negative sign is required. If mod = 1, the term will use a -1 --
		
		if (mod_val == 0) {
			sum += (1.0/(max_terms * 2 * term_index + i))
		}	
		else if (mod_val == 1) {
			sum += (-1) * (1.0/(max_terms * 2 * term_index + i))
		}
   }
  
// -- Make sure previous processing has completed --------------------------
   barrier(CLK_LOCAL_MEM_FENCE);

// -- After previous operations have completed, when the max term is -------
// -- reached, move local sum value to sum, and sum to the output-----------

	if(term_index == (max_terms - 1)) {  
		sum += sum_local[0];
		sum_out[0] = sum;
	} 
  
// --  Put the sum into local memory to be used again ----------------------- 
	sum_local[0] = sum; 
}
