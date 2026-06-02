cmake_minimum_required(VERSION 3.10)
project(repro LANGUAGES Fortran)

#===================================================
# config scotch
if(NOT SKOTX_ROOT)
  message(FATAL_ERROR "please add  -DSKOTX_ROOT=/path/to/skotx/ to cmake invokation")
endif()
find_library(SKOTX_LIB 
  NAMES scotch
  HINTS ${SKOTX_ROOT}
  PATH_SUFFIXES lib)

find_library(SKOTXERR_LIB 
  NAMES scotcherr
  HINTS ${SKOTX_ROOT}
  PATH_SUFFIXES lib)


if ((NOT SKOTX_LIB) OR (NOT SKOTXERR_LIB))
  message(FATAL_ERROR "Scotch libs not found")
endif()

find_path(
    SKOTX_INCLUDE_DIR
    NAMES scotchf.h
    HINTS ${SKOTX_ROOT}
    PATH_SUFFIXES include
)

add_executable(skotx_test test_mesh_build_elem.F90)
target_include_directories(skotx_test PRIVATE ${SKOTX_INCLUDE_DIR})
target_link_libraries(skotx_test ${SKOTX_LIB} ${SKOTXERR_LIB})
