# Makefile for building OpenCL programs
#
# yluo modified for compilation on multiple OS platforms
#
# Reference:
#   http://cjlarose.com/2015/02/05/makefile-for-opencl-development.html
#
UNAME_S := $(shell uname -s)

# on MacOS
ifeq ($(UNAME_S),Darwin)
OPENCLC=/System/Library/Frameworks/OpenCL.framework/Libraries/openclc
BUILD_DIR=./build
EXECUTABLE=main
.SUFFIXES:
KERNEL_ARCH=i386 x86_64 gpu_32 gpu_64
BITCODES=$(patsubst %, mykernel.cl.%.bc, $(KERNEL_ARCH))

$(EXECUTABLE): $(BUILD_DIR)/mykernel.cl.o $(BUILD_DIR)/main.o $(BITCODES)
	clang -framework OpenCL -o $@ $(BUILD_DIR)/mykernel.cl.o $(BUILD_DIR)/main.o

$(BUILD_DIR)/mykernel.cl.o: mykernel.cl.c
	mkdir -p $(BUILD_DIR)
	clang -c -Os -Wall -arch x86_64 -o $@ -c mykernel.cl.c

$(BUILD_DIR)/main.o: main.c mykernel.cl.h
	mkdir -p $(BUILD_DIR)
	clang -c -Os -Wall -arch x86_64 -o $@ -c $<

mykernel.cl.c mykernel.cl.h: mykernel.cl
	$(OPENCLC) -x cl -cl-std=CL1.1 -cl-auto-vectorize-enable -emit-gcl $<

mykernel.cl.%.bc: mykernel.cl
	$(OPENCLC) -x cl -cl-std=CL1.1 -Os -arch $* -emit-llvm -o $@ -c $<

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) mykernel.cl.h mykernel.cl.c $(EXECUTABLE) *.bc
endif

# on Linux for Intel FPGA OCL
ifeq ($(UNAME_S),Linux)

# You must configure ALTERAOCLSDKROOT to point the root directory of the Intel(R) FPGA SDK for OpenCL(TM)
# software installation.
# See http://www.altera.com/literature/hb/opencl-sdk/aocl_getting_started.pdf 
# for more information on installing and configuring the Intel(R) FPGA SDK for OpenCL(TM).

ifeq ($(VERBOSE),1)
ECHO :=
else
ECHO := @
endif

# Where is the Intel(R) FPGA SDK for OpenCL(TM) software?
ifeq ($(wildcard $(ALTERAOCLSDKROOT)),)
$(error Set ALTERAOCLSDKROOT to the root directory of the Intel(R) FPGA SDK for OpenCL(TM) software installation)
endif
ifeq ($(wildcard $(ALTERAOCLSDKROOT)/host/include/CL/opencl.h),)
$(error Set ALTERAOCLSDKROOT to the root directory of the Intel(R) FPGA SDK for OpenCL(TM) software installation.)
endif

# OpenCL compile and link flags.
AOCL_COMPILE_CONFIG := $(shell aocl compile-config ) -DAOCL -O2 -fPIC -Iaocl_common/inc
AOCL_LINK_CONFIG := $(shell aocl link-config ) 

# Compilation flags
ifeq ($(DEBUG),1)
CXXFLAGS += -g
else
CXXFLAGS += -O2
endif

# Compiler
CXX := g++
AOC := aoc

# Target
TARGET := main
TARGET_DIR := bin

# Directories
INC_DIRS := ../common/inc 
LIB_DIRS :=


# Files
INCS := $(wildcard )
SRCS := $(wildcard *.cpp *.c ../common/src/AOCLUtils/*.cpp)
LIBS := rt pthread

KERNEL := mykernel
AOCX := $(KERNEL).aocx
CMDMSG := "To run the emulated device: \n   cd bin \n   CL_CONTEXT_EMULATOR_DEVICE_INTELFPGA=1 ./main"

# Make it all!
all : $(TARGET_DIR)/$(TARGET)

# Host executable target.
$(TARGET_DIR)/$(TARGET) : Makefile $(SRCS) $(INCS) $(TARGET_DIR)
	$(ECHO)$(CXX) $(CPPFLAGS) $(CXXFLAGS) -fPIC $(foreach D,$(INC_DIRS),-I$D) \
                        $(AOCL_COMPILE_CONFIG) $(SRCS) $(AOCL_LINK_CONFIG) \
                        $(foreach D,$(LIB_DIRS),-L$D) \
                        $(foreach L,$(LIBS),-l$L) \
                        -o $(TARGET_DIR)/$(TARGET)

$(TARGET_DIR) :
	$(ECHO)mkdir $(TARGET_DIR)
        
emu: $(KERNEL).emu $(TARGET_DIR)/$(TARGET)

$(KERNEL).emu: $(KERNEL).cl
	$(AOC) -march=emulator -board=pac_a10 $< -o $(TARGET_DIR)/$(AOCX) 
	echo $(CMDMSG)

fpga: $(KERNEL).aocx $(TARGET_DIR)/$(TARGET)

$(KERNEL).aocx: $(KERNEL).cl
	$(AOC) -board=pac_a10 --report $< -o $(TARGET_DIR)/$(AOCX) 

# Standard make targets
clean :
	$(ECHO)rm -rf $(TARGET_DIR)/$(TARGET) $(TARGET_DIR)/$(KERNEL)*

.PHONY : all clean

endif
