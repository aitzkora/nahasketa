cmake_minimum_required (VERSION 3.0)
project (HeatModernFortran)
enable_language(Fortran)

# Define the test suite.
enable_testing()

# Check whether MPI support is available.
find_package(MPI)
if (MPI_FOUND)
  message(STATUS "MPI found; ersions")
  include_directories(${MPI_INCLUDE_PATH})
  add_library(heat SHARED heat_solve.f90 communications.f90 heat.f90)
  target_link_libraries(heat ${MPI_Fortran_LIBRARIES})
else(MPI_FOUND)
    message(FATAL_ERROR "MPI not found; you NEED it to compile the project")
endif(MPI_FOUND)
