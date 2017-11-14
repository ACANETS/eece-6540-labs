// Courtney Ross
// Lab 2
// 11/14/2017
// pi_over_4.cl

__kernel void pi_over_4(
    __global double *sum_out,
    int work_items,
	int max_terms) 
{

// -- Define local variables --------------------------------------------
__local double sum_local[1]; 
__local int mod_val;

// -- Define global term index and float for sum of terms ---------------
    int term_index 	= get_global_id (0);
    double sum 		= 0.0f; 
	
// -- Make sure previous processing has completed ------------------------
	barrier(CLK_LOCAL_MEM_FENCE);
	
// -- Using a loop, index through terms using max terms value and work- -- 
// -- items to correctly calculate terms in pi/4--------------------------

	for (int i = 0; i < max_terms; i++) {
		mod_val = fmod((int)(i), (int)2);
		
		// using modulo base 2 operations, determine the sign required ----
		// to complete the term for the calculation. If mod = 0, no -------
		// negative sign is required. If mod = 1, the term will use a -1 --
		
		// if (i == 0 || 2 || 4 || 6) {
		if (mod_val == 0) {
			sum += (1.0/( 1 + max_terms * 2 * term_index + 2 * i));
			
		}// endif
		
		// if (i == 1 || 3 || 5 || 7) {
		else if (mod_val == 1) {
			sum += (-1) * (1.0/( 1 + max_terms * 2 * term_index + 2 * i));
		}// endif
	
	/*
	if(term_index == 0){
	// verified that this works for the term_index == 0 case
	// returns 0.754268
	printf ("i = %i \t", i);				
	printf ("max_terms = %i \t", max_terms);
	printf ("sum = %lf \n", sum);
	} //endif
	*/

	/*
	// verified that numbers track expected numbers
	printf ("i = %i \t", i);				
	printf ("term_index = %i \t", term_index);
	printf ("sum = %lf \n", sum);
	*/
		
   }// end for
  
// -- Make sure previous processing has completed --------------------------
   barrier(CLK_LOCAL_MEM_FENCE);

// -- After previous operations have completed, when the max term is -------
// -- reached, move local sum value to sum, and sum to the output-----------
	
	 printf ("Work Item = %i \t", term_index);
	 printf ("Current Value = %lf \t", sum);
	 printf("\n");

// --  Put the sum into local memory to be used again ----------------------- 
	sum_local[0] += sum; 	
	
	printf ("Running Value = %lf", sum_local[0]);
	printf("\n");
	
barrier(CLK_GLOBAL_MEM_FENCE);
	if(term_index == (max_terms - 1)) {  
		//sum += sum_local[0];
		sum_out[0] = sum_local[0];
	} //end if
  

}// end main
