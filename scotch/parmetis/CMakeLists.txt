cmake_minimum_required(VERSION 3.10)
project(testparmetis)
enable_language(C)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/Modules)
find_package(ParMetis)
find_package(MPI)
if(NOT MPI_FOUND)
  message(FATAL_ERROR "MPI Not FOUND")
endif(NOT MPI_FOUND)

add_executable(test_parmetis test_libparmetis_dual2.c)
target_link_libraries(test_parmetis ${PARMETIS_LIB} ${METIS_LIB} ${MPI_C_LIBRARIES})
target_include_directories(test_parmetis PRIVATE ${PARMETIS_INC} ${MPI_INCLUDE_PATH})
