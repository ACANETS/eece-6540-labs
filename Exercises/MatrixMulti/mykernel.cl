// Courtney Ross
// EECE 6540: Hetergenous Computing
// 10/31/2017
// Lab 1

/* widthA=heightB for valid matrix multiplication */
__kernel void simpleMultiply(
    __global float *outputD,
    int widthA,
    int heightA,
    int widthB,
    int heightB,
	// Add additional height and width ints to support matrix C. Since B is the same size, these are redundant
	int heightC,
	int widthC,
    __global float *inputA,
    __global float *inputB,
	// Add addtional input C for the matrix being added to the product
	__global float *inputC)
{
    /* get global position in Y direction */
    int row = get_global_id (1);
    /* get global position in X direction */
    int col = get_global_id (0);
	
	/* Create addtional float value as an interim value to complete the multiply operation*/    
	float sum 		= 0.0f;
	/* Create addtional float value as an interim value to complete the add operation*/
	float matrixABC = 0.0f;

    /* calculate result of one element of Matrix A*B */
    for (int i=0; i<widthA; i++) {
        sum += inputA[row*widthA + i] * inputB[i*widthB + col];
    }
	
	/* Using the sum which represents one element at a times of A*B, add the corresponding element of matrix C*/
	matrixABC = sum + inputC[row*widthB + col];
	
	/* Put each element of A*B+C into the appriopriate spot in the ouput matrix */
	outputD[row*widthC + col] = matrixABC;
}
