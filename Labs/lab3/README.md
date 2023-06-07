# EECE.4510/5510 Heterogeneous Computing - Lab 3

## Part 0: Practice Jupyter Notebooks and oneAPI Base Training Modules 0-2

We will use Jupyter to run the some training modules in this lab. JupyterLab and its notebooks provide a web-based interface to interact with the Intel Developer Cloud environment. It is an option for those who are not keen with Terminals and command lines. Please follow through the Intel oneAPI Base Training Module 0 at (https://devcloud.intel.com/oneapi/get_started/baseTrainingModules/) to learn how to use Jupyter notebooks. You will need to login using registered user credentials.

Then you will proceed to Module 1 "Introduction to oneAPI and SYCL" and Module 2 "SYCL* Program Structure".

You do __not__ need to complete the lab exercises in these modules. Please capture screenshots once you complete the modules.

__NOTE:__ you might encounter a path error when launching Module 2. If that happens, please navigate to "oneAPI_Essentials/02_SYCL_Program_Structure/SYCL_Program_Structure.ipynb" using the file explore panel on your jupyter notebook page.

## Part 1: Build and Execute a DPC++ Program on DevCloud using CPU, GPU or FPGA

We use a DPC++ example program that implements Monte Carlo method to calculate Pi. Please take some time to have a good understanding of the [Monte Carlo method](https://www.geeksforgeeks.org/estimating-value-pi-using-monte-carlo/). Pay attention to how the sample program, which is included in this lab folder, exploits and expresses the parallelism in the computation. 

In this lab, you will compile and run the program on different hardware targets that are available on the Intel DevCloud: CPU, GPU, and FPGA. You can follow the specific intructions below for these targets.

### CPU
First you need to jump onto a compute node from the head node.

```
    devcloud_login
```
Choose option 5).

Change directory to the "MonteCarloPi/". Then run the following commands to compile the source and generate the executable.

```
    mkdir build
    cd build
    cmake ..
    make
```

Finally, to execute the code, do
```
    make run
```

### GPU

First you need to jump onto a compute node with GPU from the head node. To select a node with GPU, you need to do the following:

```
    qsub -I -l nodes=1:gpu:ppn=2 -d .
```

After login to the allocated GPU node, you can proceed with the same command as for CPU. You can even try "make run" directly.

### FPGA

To select a FPGA node, you can do

```
    devcloud_login
```
Choose option 2).

You will need to modify slightly the source code as the FPGA emulation is not set as the "default" device. Specifically, you need to add the following lines at the header section of monte_carlo_pi.cpp:

```
#include <sycl/ext/intel/fpga_extensions.hpp>
```
and comment out the line
```
  queue q(default_selector_v);
```
and add the following
```
  ext::intel::fpga_emulator_selector d_selector;
  //ext::intel::fpga_selector d_selector;
  queue q(d_selector);
```

You can see that we could also use fpga_selector to run the kernel function on an FPGA card. But the compilation will take some time.

## Part 2 [EECE.5510 Only]: Scale up the Calculation and Compare the Performance on CPU and GPU.

If you run the compiled code on DevCloud for a few times, you may notice that the
result of calculated Pi varies. Please think about the reason and find a way to
improve the precision of Pi to as many fractional digits as possible.

(1) Explain your revision in the report and attach a screenshot to show the
improved precision.

(2) Run the improved code on a CPU and a GPU compute node available on
DevCloud, then compare their execution times. Explain your findings.
