cmake_minimum_required(VERSION 3.10)
project(testiso)
enable_language(Fortran C)
add_executable(testiso  use_haha.f90 haha.c)
