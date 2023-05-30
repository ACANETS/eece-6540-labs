# EECE.4510/5510 Heterogeneous Computing - Lab 2

## Part 1: Practice Building and Executing a DPC++ Program

As we start learning oneAPI and DPC++, we now delve into some concrete DPC++ program examples. In this lab, you will practice DPC++ design flow on Intel Developer Cloud in Part 1. The example program illustrates how data are managed and how kernel functions are defined, which are among the essential operations in a data parallel design using DPC++. 

## `matrix-multiplication` Sample

We use matrix multiplication example to show how to design data parallel programs in DPC++. Using it, we demonstrate how "thinking-in-parallel" helps take advantage of the parallelism in a task and implement it in DPC++. 

| Optimized for                     | Description
|:---                               |:---
| OS                                | Linux* Ubuntu* 18.04
| Hardware                          | Skylake with GEN9 or newer, Intel(R) Programmable Acceleration Card with Intel(R) Arria(R) 10 GX FPGA
| Software                          | Intel&reg; oneAPI DPC++ Compiler (beta)  
  
The compilation and run-time profiling are performed on Intel FPGA DevCloud, a free development platform.

## Purpose

We use matrix-multi example to demonstrate how DPC++ supports kernel functions that define how computation is carried out on a partition of the whole dataset or task. 

## Key Implementation Details 
The DPC++ implementations explained in the several versions covers basic concepts of DPC++ programming such as device selector, and parallel_for().

## License  
This code sample is licensed under MIT license. 

## Building the `matrix-multi` Program for Intel(R) FPGA

### On a Linux* System

**The project uses CMake. Perform the following steps to build different targets.** 

```
    mkdir build
    cd build
    cmake ..
    make
```
Optionally, you can also do the following.
```
    make report
    make fpga
    make profile
```
* make : by default, the emulation executables are built.
* make report : generate static report on the FPGA resource utilization of the designs.
* make fpga : generate FPGA binary files for the designs. Will take a couple of hours.
* make profile : generate FPGA binary to be used in run-time profiling. Will take a couple of hours.

## Running the Sample

The executables (for emulation or for FPGA hardware) can be found in the build directory. Use the file name(s) to executable the samples. For example
    ```
    ./matrix-multi-para.fpga_emu
    ```

### Application Parameters
There are no editable parameters for this sample.

### Example of Output

* emulation on a Linux platform.
<pre>
1 found ..
Platform: Intel(R) FPGA Emulation Platform for OpenCL(TM)
Device: Intel(R) FPGA Emulation Device
2 found ..
Platform: Intel(R) OpenCL
Device: Intel(R) Core(TM) i7-7700K CPU @ 4.20GHz
3 found ..
Platform: Intel(R) OpenCL HD Graphics
Device: Intel(R) Graphics [0x5912]
4 found ..
Platform: Intel(R) Level-Zero
Device: Intel(R) Graphics [0x5912]
5 found ..
Platform: SYCL host platform
Device: SYCL host device

computing on host...
1.83809 seconds
Running on device: Intel(R) FPGA Emulation Device
Matrix A size: 800,1000
Matrix B size: 1000,2000
Matrices C, D size: 800,2000
MatrixMultiplication using parallel_for().
0.183899 seconds
Matrix multiplication successfully completed on device.

</pre>

## Recorded Lectures

A series of recorded lectures are provided to introduce the important concepts about DPC++ programming for FPGAs. The videos can be found at the [DPC++ Tutorial playlist](https://youtube.com/playlist?list=PLZ9YeF_1_vF8RqYPNpHToklJcDRoVocU4) on Youtube and are linked individually below. 

Watching these videos for Lab 2 is optional but recommended.

[Introduction to DPC++](https://youtu.be/F2DWVuJRvfM)

[How to Think "in Parallel"?](https://youtu.be/3DTYEBSrj-U)


## Part 2 [EECE.5510 ONLY]: Design a DPC++ Program to Perform Image Rotation

You will design your first DPC++ program that performs image rotation operation. To learn about the algorithm behind image rotation, you need to refer to the lecture notes on Image Rotation, and the recorded video to review the mathematical principles behind image rotation operations. 

[Lecture notes on Image Rotation](Image-Rotation-Conv.pdf)
[Recorded lecture on Image Rotation](https://youtu.be/8wCEcxjSbBs)

The example code under Exercises/ImageRotation folder within our eece-6540-labs repository [2] shows how to implement the algorithm in OpenCL. The image-conv example in [DPCPP Tutorials](https://github.com/ACANETS/dpcpp-tutorial) shows how to handle image files in DPC++. To port image-rotation algorithm in DPC++, you should think about what data memory objects to use and how to partition the data and design the kernel operations in a lambda function. 

You can use the skeleton code of image rotation given in this folder as a start to implement your complete design.  

