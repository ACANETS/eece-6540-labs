__kernel
void img_rotate(
    __global float * dest_data,
    __global float * src_data,
    int W, int H,
    float sinTheta, float cosTheta)
{
   /* work-item gets its index */
   const int ix = get_global_id(0);
   const int iy = get_global_id(1);

   /* calculate location of data to move int (ix, iy)
    * output decomposition as mentioned */
   float xpos = ((float)ix)*cosTheta + ((float)iy)*sinTheta;
   float ypos = -1.0f*((float)ix)*sinTheta + ((float)iy)*cosTheta;


   /* Bound checking */
   if(((int)xpos >= 0) && ((int)xpos < W) &&
      ((int)ypos >= 0) && ((int)ypos < H) )
   {
      /* read (ix,iy) src data and store at (xpos,ypos)
       * in dest data
       * in this case, because we rotate about the origin and
       * there is no translation, we know that (xpos, ypos) will be
       * unique for each input (ix, iy) and so each work-item can
       * write its results independently
       */
       dest_data[(int)ypos * W + (int)xpos] = src_data[iy*W+ix];
   }
}
