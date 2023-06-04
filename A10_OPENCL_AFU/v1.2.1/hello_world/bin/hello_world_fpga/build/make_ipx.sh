#!/bin/bash

# (C) 2017 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other
# software and tools, and its AMPP partner logic functions, and any output
# files any of the foregoing (including device programming or simulation
# files), and any associated documentation or information are expressly subject
# to the terms and conditions of the Intel Program License Subscription
# Agreement, Intel MegaCore Function License Agreement, or other applicable
# license agreement, including, without limitation, that your use is for the
# sole purpose of programming logic devices manufactured by Intel and sold by
# Intel or its authorized distributors.  Please refer to the applicable
# agreement for further details.

ip-make-ipx --source-directory="ccip_iface/*/,ip/*/,$INTELFPGAOCLSDKROOT/ip/board" --output=iface.ipx  --relative-vars=INTELFPGAOCLSDKROOT

#clean up the generated iipx files to remove absolute paths
sed -i 's/\/*data.*\/build\/ip/ip/g' *.iipx
