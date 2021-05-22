# eece-6540-labs
Labs and Exercises for EECE.6540 Heterogeneous Computing

## Set up SSH access to Intel DevCloud

Once you received login credentials from Intel DevCloud, please follow the instructions to setup SSH access to Intel DevCloud

https://github.com/intel/FPGA-Devcloud/tree/master/main/Devcloud_Access_Instructions#devcloud-access-instructions

## Set up lab environment on Intel DevCloud

You need to be able to SSH into DevCloud before proceeding with the following steps. DevCloud has two categories of "nodes": *Head Node* and *Compute Node*. The Head Node is the landing point once you login via SSH whereas a Compute Node is where the main code development work happens. The general principle is that you should only use Compute Nodes for development tasks (compilation, testing, debugging), so running any of these tasks on the Head Node is not supported and will lead to errors.

### On Head Node
Once you have set up the SSH key to access, you should be able to login the headnode (identified as "login-2").

On the head node, you need to run the following command to select a compute node that supports OpenCL or OneAPI 

```
devcloud_login
```

For OpenCL labs please choose option 1)
```
1) Arria 10 PAC Compilation and Programming - RTL AFU, OpenCL
```
Then choose option 1) for OpenCL version 1.2.1
```
1) 1.2.1
```

For OneAPI labs please choose Option 2)
```
2) Arria 10 OneAPI
```

Either way, you will be directed to a compute node (identified as @s00x-nxxx) shortly. 

### On Compute Node
Then you will need to run the following command to set up the environment variables before compilation.

```
tools_setup
```
