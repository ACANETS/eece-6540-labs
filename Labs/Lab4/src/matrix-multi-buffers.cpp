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

#include <CL/sycl.hpp>
#include <array>
#include <iostream>
#include "dpc_common.hpp"
#if FPGA || FPGA_EMULATOR
#include <CL/sycl/intel/fpga_extensions.hpp>
#endif

using namespace sycl;

// Integer Matrix class
class IntMatrix {
  public:
    size_t row, column;
    std::vector<int> elements;
  // constructor
  IntMatrix(size_t r, size_t c, int initVal) {
    row = r;
    column = c;
    elements = std::vector<int>(r*c, initVal);
  }
  // quick access to element at row r and column c
  int e(size_t r, size_t c) {
    return elements[r*column+c];
  }
};

// matrice shapes for this example.
constexpr size_t a_rows = 200;
constexpr size_t a_columns = 400;
constexpr size_t b_columns = 600;

// matrix A size: a_rows x a_columns
// matrix B size: a_columns x b_columns
// matrices C an D size: a_rows x b_columns

//************************************
// Matrix multiplication in DPC++ on device: returns sum in 5th parameter "matrix_d_parallel".
//************************************
void MatrixMulti(queue &q, const IntMatrix &matrix_a, const IntMatrix &matrix_b, const IntMatrix &matrix_c,
               IntMatrix &matrix_d_parallel) {

  // Create the range object for the arrays managed by the buffer.
  range<2> num_items{matrix_d_parallel.row, matrix_d_parallel.column};
  // get the width of matrices so that we can use in the kernel function.
  size_t widthA = matrix_a.column;
  // TODO: get widthB 
  // NEED 1 lines.
  size_t widthC = matrix_c.column;

  // Create buffers that hold the data shared between the host and the devices.
  // The buffer destructor is responsible to copy the data back to host when it
  // goes out of scope.
  // TODO: create buffers for matrices A and B
  // NEED 2 lines
  buffer c_buf(matrix_c.elements);
  
  // TODO: create buffer for matrix D, whose value needs to be copied from device after being computed
  // Example in vector_add example:
  //     buffer sum_buf(sum_parallel.data(), num_items);
  // the 1st argument is the pointer to raw data memory (xxx.data())
  // the 2nd argument is range<1> type, initialized with the size of the buffer <SIZE>
  //
  // In our case, we have two options:
  // (a) treat the buffer as a one-dimensional buffer
  //    buffer sum_buf(matrix_d_parallel.elements.data(), num_items);
  //    In this case, num_items should be range<1> type, with value {matrix_c.row*matrix_c.column}
  //    in the kernel function, we should use sum[row * widthD + column] to access the element
  //
  // (b) treat the buffer as a two-dimensional buffer  
  //    buffer sum_buf(matrix_d_parallel.elements.data(), num_items);
  //    the num_items should be of range<2>type, with value {matrix_c.row, matrix_c.column}
  //    in the kernel function, we can use sum[row][column] to access element (i,j)
  buffer<int,2> sum_buf(matrix_d_parallel.elements.data(), num_items);

  // Submit a command group to the queue by a lambda function that contains the
  // data access permission and device computation (kernel).
  q.submit([&](handler &h) {
    // Create an accessor for each buffer with access permission: read, write or
    // read/write. The accessor is a mean to access the memory in the buffer.
    // TODO: create accessors for matrices A and B
    // NEED 2 lines
    auto c = c_buf.get_access<access::mode::read>(h);
    
    // The sum_accessor is used to store (with write permission) the sum data.
    auto sum = sum_buf.get_access<access::mode::write>(h);
  
    // Use parallel_for to run vector addition in parallel on device. This
    // executes the kernel.
    //    1st parameter is the number of work items.
    //    2nd parameter is the kernel, a lambda that specifies what to do per
    //    work item. The parameter of the lambda is the work item id.
    // DPC++ supports unnamed lambda kernel by default.
    h.parallel_for(num_items, [=](id<2> i) 
      { 
        // identify the element to compute
        size_t c_row = i[0], c_col = i[1];
        //TODO: initialize the element (c_row, c_col) in sum to be zero
        //NEED one line

        // for loop to do element wise multiplication and accumulation
        for (size_t k = 0; k < widthA; k++)
          //TODO element wise multiplication and accumulate to sum
          //     you can refer to Lab 1
          //NEED one line
        
        // add the element in Matrix C to Matrix D.
        // note how we access the element in C, which is a one-dimensional buffer
        sum[c_row][c_col]  += c[c_row*widthC + c_col];
      }
    );
  });
}


//************************************
// Demonstrate vector add both in sequential on CPU and in parallel on device.
//************************************
int main() {
  // Create device selector for the device of your interest.
#if FPGA_EMULATOR
  // DPC++ extension: FPGA emulator selector on systems without FPGA card.
  intel::fpga_emulator_selector d_selector;
#elif FPGA
  // DPC++ extension: FPGA selector on systems with FPGA card.
  intel::fpga_selector d_selector;
#else
  // The default device selector will select the most performant device.
  default_selector d_selector;
#endif

  // Query about the platform
/*
  unsigned number = 0;
  auto myPlatforms = platform::get_platforms();
  // loop through the platforms to poke into
  for (auto &onePlatform : myPlatforms) {
    std::cout << ++number << " found .." << std::endl << "Platform: " 
    << onePlatform.get_info<info::platform::name>() <<std::endl;
    // loop through the devices
    auto myDevices = onePlatform.get_devices();
    for (auto &oneDevice : myDevices) {
      std::cout << "Device: " 
      << oneDevice.get_info<info::device::name>() <<std::endl;
    }
  }
*/

  // Create matrix objects with row, column and initial value 
  // to store the input and output data.
  IntMatrix a(a_rows, a_columns, 1);
  IntMatrix b(a_columns, b_columns, 2);
  IntMatrix c(a_rows, b_columns, 3);
  IntMatrix sum_sequential(a_rows, b_columns, 0);
  IntMatrix sum_parallel(a_rows, b_columns, 0);

  try {
    queue q(d_selector, dpc::exception_handler);

    // Print out the device information used for the kernel code.
    std::cout << "Running on device: "
              << q.get_device().get_info<info::device::name>() << "\n";
    std::cout << "Matrix A size: " << a.row << "," << a.column << std::endl;
    std::cout << "Matrix B size: " << b.row << "," << b.column << std::endl;
    std::cout << "Matrices C, D size: " << sum_parallel.row << "," 
              << sum_parallel.column << std::endl;

    // Matrix multiplication in DPC++
    MatrixMulti(q, a, b, c, sum_parallel);
  } catch (exception const &e) {
    std::cout << "An exception is caught for matrix multiplication.\n";
    std::terminate();
  }

  size_t widthA = a.column;
  size_t widthB = b.column;
  size_t widthC = sum_sequential.column;

  // Compute the sum of two arrays in sequential for validation.
  for (size_t i = 0; i < sum_sequential.row; i++)
    for (size_t j = 0; j < sum_sequential.column; j++) {
      sum_sequential.elements[i*widthC+j] = c.e(i,j);
      for (size_t k = 0; k < widthA; k++)
        sum_sequential.elements[i*widthC+j] += a.e(i,k) * b.e(k,j);
    }

  // Verify that the two arrays are equal.
  for (size_t i = 0; i < sum_sequential.row; i++)
    for (size_t j = 0; j < sum_sequential.column; j++) 
      if(sum_sequential.e(i,j) != sum_parallel.e(i,j)) {
        std::cout << "not equal" << std::endl;
        return -1;
      }

/*
  // Print out the result of matrix multiplication.
  std::cout<<"-- sum_sequential --"<<std::endl;
  for (size_t i = 0; i < sum_sequential.row; i++) {
    for (size_t j = 0; j < sum_sequential.column; j++) 
      std::cout << sum_sequential.e(i,j) << " ";
    std::cout << "\n";
  }

  // Print out the result of matrix multiplication.
  std::cout<<"** sum_parallel **"<<std::endl;
  for (size_t i = 0; i < sum_parallel.row; i++) {
    for (size_t j = 0; j < sum_parallel.column; j++) 
      std::cout << sum_parallel.e(i,j) << " ";
    std::cout << "\n";
  }
*/

  std::cout << "Matrix multiplication successfully completed on device.\n";
  return 0;
}
