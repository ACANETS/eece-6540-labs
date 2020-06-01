# eece-6540-labs
labs and exercises for EECE.6540 Heterogeneous Computing

## set up SSH access to Intel DevCloud

Once you received login credentials from Intel DevCloud, please follow the instructions to setup SSH access to Intel DevCloud

https://github.com/intel/FPGA-Devcloud/tree/master/main/Devcloud_Access_Instructions#devcloud-access-instructions

## set up lab environment on Intel DevCloud

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

Either way, you will be directed to a compute node (identified as @s001-nxxx) shortly. 

### On Compute Node
Then you will need to run the following command to set up the environment variables before compilation.

```
tools_setup
```
