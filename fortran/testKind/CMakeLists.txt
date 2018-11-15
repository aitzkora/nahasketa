cmake_minimum_required(VERSION 3.10)
project(hehe)
enable_language(Fortran)
include(testKind.cmake)
list(APPEND CMAKE_MODULE_PATH
    ${CMAKE_SOURCE_DIR}/
     )

CHECK_KIND_SIZE_IS_SUPPORTED(8 HAHA)
