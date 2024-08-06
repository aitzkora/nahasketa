cmake_minimum_required(VERSION 3.15)
cmake_policy(SET CMP0148 OLD )
enable_language(C)
project(example_call_back DESCRIPTION "illustrate how to set a callback from Python")

set(callback_dist ${CMAKE_SOURCE_DIR}/callback-dist)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
add_library(compute_sqrt SHARED compute_sqrt.c)

add_custom_target(
  copylib ALL 
  COMMENT "copy library" 
  DEPENDS compute_sqrt
  COMMAND ${CMAKE_COMMAND} -E copy 
  $<TARGET_FILE:compute_sqrt> ${CMAKE_BINARY_DIR}/libtemp/libcompute_sqrt.so)

set(libsqrt "${CMAKE_BINARY_DIR}/libtemp/libcompute_sqrt.so")
configure_file(setup.py.in setup.py)
file(COPY ${CMAKE_SOURCE_DIR}/callback DESTINATION ${CMAKE_BINARY_DIR}/callback)
find_package(PythonInterp REQUIRED)
if (NOT PYTHON_EXECUTABLE)
  message(SEND_ERROR "Could not find python executable")
  return()
endif()


set(setup.py ${CMAKE_BINARY_DIR}/setup.py)
add_custom_target(
    callback ALL
    COMMENT "Building callback library with setup.py"
    SOURCES ${setup.py}
    DEPENDS ${setup.py}
    VERBATIM
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    #COMMAND ${PYTHON_EXECUTABLE} ${setup.py}
    #build_ext -b ${CMAKE_BINARY_DIR}/python_ext -d ${CMAKE_BINARY_DIR}/callback-dist
    COMMAND ${PYTHON_EXECUTABLE} ${setup.py}
    bdist_wheel -b ${CMAKE_BINARY_DIR}/python_ext -d ${CMAKE_BINARY_DIR}/callback-dist)

add_dependencies(callback copylib)
