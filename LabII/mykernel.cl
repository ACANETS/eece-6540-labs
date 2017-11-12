__kernel void Pi(

	__global float *workGroupBuffer,        // float vector partial sum NumWorkGroups
	__local float *scratch,  				// local sum workGroupSize
		
{
	int lid = get_local_id(0);		// local id
	int gid = get_global_id(0);		// global id index
	int chunk = 8;					// Max number of terms is set to 8 
	int index = 0;					// bounded
	float Cur_Val = 0.0f;
	float Calc_Val = 0.0f; 	
	
	for index = 0 : (chunk-1)
	{
		Cur_Val = 1/(1 + 2*index + 16*lid);
               If mod(index,2) == 0; 					// add if even
                              Calc_Val += Cur_Val;
               Else // mod(index,2) == 1; 				// subtract if odd
			   {
                              Calc_Val += -1*Cur_Val;
			   }
	}

	barrier(CLK_LOCAL_MEM_FENCE);
	
	}

	// Each thread store its partial sum in the workgroup array
	scratch[lid] = partial_sum;

	// Synchronize all threads within the workgroup
	barrier(CLK_LOCAL_MEM_FENCE);

	float local_pi = 0;			// Only thread 0 of each workgroup perform the reduction	

	// Perform the reduction 	
		if(lid == 0) {
				const uint length = lid + get_local_size(0);
				for (uint i = lid; i<length; i++) 
				{
				local_pi += scratch[i];
				}
				
				// store workgroup sum
				workGroupBuffer[get_group_id(0)] = local_pi;
			}
		
				
				
				
				
				
				
				
				
				
				
				
				