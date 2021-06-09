# `matrix_multi` Sample

We use matrix multiplication example to show how to design data parallel programs in OpenCL. Using it, we demonstrate how "thinking-in-parallel" helps take advantage of the parallelism in a task and implement it in OpenCL. 

| Optimized for                     | Description
|:---                               |:---
| OS                                | Linux* Ubuntu* 18.04
| Hardware                          | Skylake with GEN9 or newer, Intel(R) Programmable Acceleration Card with Intel(R) Arria(R) 10 GX FPGA
| Software                          | Intel&reg; FPGA SDK for OpenCL 19.1 or later, FPGA Runtime Environment for OpenCL  
  
The compilation and run-time profiling are performed on Intel FPGA DevCloud, a free development platform.

## Purpose

We use matrix-multi example to demonstrate how OpenCL supports kernel functions that define how computation is carried out on a partition of the whole dataset or task.  

## Key Implementation Details 
The implementation covers basic concepts of OpenCL programming such as platform/device selection, command queue, buffers and kernel. 

## License  
This code sample is licensed under MIT license. 


## Building the `matrix-multi` Program for Intel(R) FPGA

**The following commands are to be executed on a Intel DevCloud Compute Node**  

### Emulation Mode
```
    cd Labs/lab2/matrix_multi
    aoc -march=emulator -v device/matrix_multi.cl -o bin/matrix_multi_emulation.aocx
    ln -sf matrix_multi_emulation.aocx bin/matrix_multi.aocx
    make
    ./bin/host -emulator
```

### FPGA Hardware Mode

```
    aoc device/matrix_multi.cl -o bin/matrix_multi_fpga.aocx -board=pac_a10
```

### Application Parameters
There are no editable parameters for this sample.

### Example of Output
