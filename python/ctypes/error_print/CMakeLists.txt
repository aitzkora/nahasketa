cmake_minimum_required(VERSION 3.9)
enable_language(C)
project(example_call_back DESCRIPTION "illustrate how to set a callback from Python")
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
add_library(compute_sqrt SHARED compute_sqrt.c)
install(TARGETS compute_sqrt DESTINATION ${CMAKE_SOURCE_DIR}/foo)

