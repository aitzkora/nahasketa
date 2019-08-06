cmake_minimum_required(VERSION 3.9)
#enable_language(Fortran)
project(testARB DESCRIPTION "try to use arb for computer whittakerW function")

# ARB config
if (NOT ARB_PREFIX)
    message(FATAL_ERROR "please defined ARB_PREFIX")
else()
    message(STATUS "ARB_PREFIX = ${ARB_PREFIX}")
endif()
find_library(ARB_LIB NAMES arb HINTS ${ARB_PREFIX}/lib)
message(STATUS "ARB_LIB = ${ARB_LIB} ")
find_path(ARB_INCLUDE_PATH NAMES arb.h HINTS ${ARB_PREFIX}/include)
message(STATUS "ARB_INCLUDE_PATH = ${ARB_INCLUDE_PATH}")
find_library(FLINT_LIB NAMES flint HINTS /usr/lib ${FLINT_LIB_DIR})
if (NOT FLINT_LIB)
    message(FATAL_ERROR "flint library not found in /usr/lib ; please define FLINT_LIB_DIR on the cmake commande line")
else()
    message(STATUS "FLINT_LIB = ${FLINT_LIB}")
endif()


add_library(compute_u compute_u.c)
target_include_directories(compute_u BEFORE PRIVATE ${ARB_INCLUDE_PATH})
target_link_libraries(compute_u PRIVATE ${ARB_LIB} ${FLINT_LIB} m)

add_executable(bidon test_bidon.c)
target_link_libraries(bidon compute_u)

enable_testing()
add_test(test1 bidon)
