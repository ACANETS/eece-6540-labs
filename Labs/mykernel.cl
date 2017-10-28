// Lab1 addition and multipli matrix
/* widthA=heightB for valid matrix multiplication */
__kernel void simpMultiAdd(
    __global float *outputD,
    int widthA,
    int heightA,
    int widthB,
    int heightB,
    int widthC,
    int heightC,	
    __global float *inputA,
    __global float *inputB,
    __global float *inputC)
{
    /* get global position in Y direction */
    int row = get_global_id (1);
    /* get global position in X direction */
    int col = get_global_id (0);

    float sum = 0.0f;
	float sum1 = 0.0f; 

    /* calculate result of one element of Matrix  */
    for (int i=0; i<widthA; i++) {
		
		// sum = A * B
        sum += inputA[row*widthA + i] * inputB[i*widthB + col];
	  }	
		// D = (sum) + C
		/* add result and calculate the addition of C */ 
			sum1 = sum + inputC[row*widthC + col];
			
	// output D should be same width size as B or C		
    outputD[row*widthC + col] = sum1;  
 
}

