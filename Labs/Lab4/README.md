//==============================================================
// EECE.6540 Heterogeneous Computing
// Lab 4 Matrix Multiplication with DPC++
//
// This is a skeleton code to be completed by students.
//
// Yan Luo. 2020.
//
// DPC++ material used in the code sample:
// •	A one dimensional array of data for buffers.
// •	A device queue, buffer, accessor, and kernel.
// based on vector_add example by Intel Corp.
//==============================================================

First, you need to make sure you are on a compute node of Intel DevCloud

You need a compute node with oneAPI SDK to work on this lab. First, you need to SSH into the head node. The on the Head Node, run the following command:

```console
devcloud_login
```

Then select option "2) Arria 10 oneAPI". You will then be directed into a Compute Node. Then run 

```console
tools_setup
```

Then choose option "6) Arria 10 OneAPI".

===

For emulation mode,

```console
make fpga_emu -f Makefile.fpga 
make run_emu -f Makefile.fpga 
```

For hardware mode,
```console
make hw -f Makefile.fpga 
make run_hw -f Makefile.fpga 
```
Note that the compilation will take about an hour.
