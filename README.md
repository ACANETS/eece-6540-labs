# eece-6540-labs
labs and exercises for EECE.6540 Heterogeneous Computing

## set up lab environment on Intel DevCloud

1. append the following lines to the end of your .bashrc file (You only need to do this once). After this line is in place, you should be able to run "devcloud_login" to select nodes 

`if [ -f /data/intel_fpga/devcloudLoginToolSetup.sh ]; then
  source /data/intel_fpga/devcloudLoginToolSetup.sh
fi
`

1. set up paths necessary for OpenCL SDK. You need to run these commands every time you login in.

`source /glob/development-tools/versions/fpgasupportstack/a10/1.2/inteldevstack/init_env.sh`

`source /glob/development-tools/versions/fpgasupportstack/a10/1.2/inteldevstack/intelFPGA_pro/hld/init_opencl.sh`
