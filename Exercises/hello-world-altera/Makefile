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

# on Linux for Altera OCL
ifeq ($(UNAME_S),Linux)
ALTERA_AOC=aoc
EXECUTABLE=main
KERNEL=mykernel
BITCODES=$(KERNEL).aocx
BITCODES-EMU=$(KERNEL).aocx-emu
BUILD_DIR=bin/
ALTERA_AOCL_INC_FLAGS=-DAOCL -O2 -fPIC -Iaocl_common/inc -I/opt/intelFPGA/16.1/hld/host/include  
ALTERA_AOCL_COMMON=aocl_common/src/AOCLUtils/opencl.cpp aocl_common/src/AOCLUtils/options.cpp 
ALTERA_AOCL_LD_FLAGS=$(shell aocl linkflags)
ALTERAOCLSDKROOT__ = ${ALTERAOCLSDKROOT}


emu: $(BITCODES).emu $(EXECUTABLE)

fpga: $(BITCODES) $(EXECUTABLE)

$(BITCODES).emu: $(KERNEL).cl
	unset AOCL_BOARD_PACKAGE_ROOT
	$(ALTERA_AOC) -march=emulator $< -o bin/$(BITCODES) 

$(BITCODES): $(KERNEL).cl
	export AOCL_BOARD_PACKAGE_ROOT=$(ALTERAOCLSDKROOT__)/board/c5soc
	$(ALTERA_AOC) $< -o bin/$(BITCODES) --report --board c5soc_sharedonly

$(EXECUTABLE): main.c
	mkdir -p $(BUILD_DIR)
	g++ $(ALTERA_AOCL_INC_FLAGS) $< $(ALTERA_AOCL_COMMON) $(ALTERA_AOCL_LD_FLAGS) -o $(BUILD_DIR)$@
	echo "To run the emulated device: "
	echo "    cd bin; CL_CONTEXT_EMULATOR_DEVICE_ALTERA=1 ./main"


.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) $(EXECUTABLE) 
endif
