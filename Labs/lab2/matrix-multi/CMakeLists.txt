set(CMAKE_CXX_COMPILER "dpcpp")
if(WIN32)
    set(CMAKE_C_COMPILER "clang-cl")
endif()

cmake_minimum_required (VERSION 2.8)

project(MatrixMulti)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

add_subdirectory (src)
