/* main.c
 *
 * show platform info
 * reference:
 *  http://dhruba.name/2012/08/13/opencl-cookbook-listing-all-platforms-and-their-attributes/
 */

 #include <stdio.h>
 #include <stdlib.h>
 #ifdef __APPLE__
 #include <OpenCL/opencl.h>
 #else
 #include <CL/cl.h>
 #endif

#ifdef AOCL                                                                     
#include "CL/opencl.h"                                                          
#include "AOCLUtils/aocl_utils.h"                                               
                                                                                
using namespace aocl_utils;                                                     
void cleanup();                                                                 
#endif                                                                          

 int main() {

     int i, j;
     char* info;
     size_t infoSize;
     cl_uint platformCount;
     cl_platform_id *platforms;
     const char* attributeNames[5] = { "Name", "Vendor",
         "Version", "Profile", "Extensions" };
     const cl_platform_info attributeTypes[5] = { CL_PLATFORM_NAME, CL_PLATFORM_VENDOR,
         CL_PLATFORM_VERSION, CL_PLATFORM_PROFILE, CL_PLATFORM_EXTENSIONS };
     const int attributeCount = sizeof(attributeNames) / sizeof(char*);

     // get platform count
     clGetPlatformIDs(5, NULL, &platformCount);
     printf("Found %d Platforms \n", platformCount);

     // get all platforms
     platforms = (cl_platform_id*) malloc(sizeof(cl_platform_id) * platformCount);
     clGetPlatformIDs(platformCount, platforms, NULL);

     // for each platform print all attributes
     for (i = 0; i < platformCount; i++) {

         printf("\n %d. Platform \n", i+1);

         for (j = 0; j < attributeCount; j++) {

             // get platform attribute value size
             clGetPlatformInfo(platforms[i], attributeTypes[j], 0, NULL, &infoSize);
             info = (char*) malloc(infoSize);

             // get platform attribute value
             clGetPlatformInfo(platforms[i], attributeTypes[j], infoSize, info, NULL);

             printf("  %d.%d %-11s: %s\n", i+1, j+1, attributeNames[j], info);
             free(info);

         }

         printf("n");

     }

     free(platforms);
     return 0;

 }

#ifdef AOCL                                                                     
// Altera OpenCL needs this callback function implemented in main.c             
// Free the resources allocated during initialization                           
void cleanup() {                                                                }                                                                               
#endif       
