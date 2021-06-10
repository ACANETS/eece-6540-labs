# `matrix_multi` Sample

We use matrix multiplication example to show how to design data parallel programs in OpenCL. Using it, we demonstrate how "thinking-in-parallel" helps take advantage of the parallelism in a task and implement it in OpenCL. 

| Optimized for                     | Description
|:---                               |:---
| OS                                | Linux* Ubuntu* 18.04
| Hardware                          | Skylake with GEN9 or newer, Intel(R) Programmable Acceleration Card with Intel(R) Arria(R) 10 GX FPGA
| Software                          | Intel&reg; FPGA SDK for OpenCL 19.1 or later, FPGA Runtime Environment for OpenCL  
  
The compilation and run-time profiling are performed on Intel FPGA DevCloud, a free development platform.

## Purpose

We use matrix_multi example to demonstrate how OpenCL supports kernel functions that define how computation is carried out on a partition of the whole dataset or task.  

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

#### Compiling for FPGA Hardware
```
    aoc device/matrix_multi.cl -o bin/matrix_multi_fpga.aocx -board=pac_a10
    cd bin
    source $AOCL_BOARD_PACKAGE_ROOT/linux64/libexec/sign_aocx.sh -H openssl_manager -i matrix_multi_fpga.aocx -r NULL -k NULL -o matrix_multi_fpga_unsigned.aocx

```
Because no root key or code signing key is provided, the script asks if you would like to create an unsigned bitstream, as shown below. Type Y to accept an unsigned bitstream.

         No root key specified. Generate unsigned bitstream? Y = yes, N = no: Y
         No CSK specified. Generate unsigned bitstream? Y = yes, N = no: Y
         
#### Downloading the bit stream into the PAC card

The executable that you run on the FPGA on the PAC card is called an .aocx file (Altera OpenCL executable).

To see what FPGA accelerator cards are available, we type the following into the terminal. 

```bash
aoc --list-boards
```

You will observe the pac_10 board is available. Next, as you did during the initial step, run the aocl diagnose command so that you can get the device name.

```
aocl diagnose
```

Observe that the device name is acl0.

Next, you need to create the unsigned version of the .aocx file. 

#### Programming the Arria 10 GX PAC Card

Next, you will program the PAC card with hello_world_fpga_unsigned.aocx (version 1.2.1) FPGA executable with one of the following commands:

```
aocl program acl0 matrix_multi_fpga_unsigned.aocx
```


#### Running the host code 

You have already run `make` to build the CPU host executable in the prior section, so it's not necessary to compile the host code again. Simply run the following command to run a heterogeneous workload that combines CPU and FPGA execution to utilizing the CPU and FPGA working in tandem.

```bash
./host
```


### Application Parameters
There are no editable parameters for this sample.

### Example of Output
