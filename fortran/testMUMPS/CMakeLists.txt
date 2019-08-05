cmake_minimum_required (VERSION 2.6)
project (test_MUMPS)
enable_language (Fortran)

find_package(MPI)
# include path for mpi module
if (MPI_FOUND)
    message(STATUS "MPI found")
    if (MPI_Fortran_HAVE_F77_HEADER) 
        message(STATUS "directory for deprecated F77 (😒) HEADER module ${MPI_Fortran_F77_HEADER_DIR}")
    else()
        message(FATAL_ERROR "you mpi distribution must have a module deprecated (😒) mpif.h due to MUMPS")
    endif()
    message(STATUS "MPI LIBRARIES  = ${MPI_Fortran_LIBRARIES}")
    include_directories(${MPI_INCLUDE_PATH})
    include_directories(${MPI_Fortran_F77_HEADER_DIR})
else()
    message(FATAL_ERROR "MPI not found")
endif()

if ( (NOT MUMPS_INCLUDE_PATH  ) OR 
     (NOT MUMPS_LIB_DIR ) OR 
     (NOT SCOTCH_INCLUDE_PATH  ) OR 
     (NOT SCOTCH_LIB_DIR ) OR 
     (NOT SCALAPACK_LIB_DIR ) OR 
     (NOT BLAS_LIB_DIR ) OR 
     (NOT LAPACK_LIB_DIR  ))
     message(FATAL_ERROR "these variables MUST be defined :
     - MUMPS_INCLUDE_PATH
     - MUMPS_LIB_DIR
     - SCOTCH_INCLUDE_PATH
     - SCOTCH_LIB_DIR
     - SCALAPACK_LIB_DIR
     - BLAS_LIB_DIR
     - LAPACK_LIB_DIR
     Please copy config/preload.cmake and modify for suiting to your config")
else()
     message(STATUS " predefined variables
  --------------------
  - MUMPS_INCLUDE_PATH =  ${MUMPS_INCLUDE_PATH}
  - MUMPS_LIB_DIR = ${MUMPS_LIB_DIR}
  - SCOTCH_INCLUDE_PATH = ${SCOTCH_INCLUDE_PATH}
  - SCOTCH_LIB_DIR = ${SCOTCH_LIB_DIR}
  - SCALAPACK_LIB_DIR = ${SCALAPACK_LIB_DIR}
  - BLAS_LIB_DIR = ${BLAS_LIB_DIR}
  - LAPACK_LIB_DIR = ${LAPACK_LIB_DIR}")
endif()

# MUMPS Config
find_library(MUMPS_LIB NAMES zmumps HINTS ${MUMPS_LIB_DIR})
message(STATUS "MUMPS_LIB = ${MUMPS_LIB}")
find_library(MUMPS_COMMON_LIBRARY NAMES mumps_common HINTS ${MUMPS_LIB_DIR})
message(STATUS "MUMPS_COMMON_LIBRARY = ${MUMPS_COMMON_LIBRARY}")
find_library(MUMPS_PORD_LIBRARY NAMES pord HINTS ${MUMPS_LIB_DIR})
message(STATUS "MUMPS_PORD_LIBRARY = ${MUMPS_PORD_LIBRARY}")

 # FIXME : check for existing header in that directory
include_directories(${MUMPS_INCLUDE_PATH}) 

# Scotch config
find_library(SCOTCH_LIB NAMES  ptesmumps HINTS ${SCOTCH_LIB_DIR})
message(STATUS "SCOTCH_LIB = ${SCOTCH_LIB}")

#find_library(PTHREAD_LIB NAMES  pthread HINTS ${PTHREAD_LIB_DIR})
#message(STATUS "PTHREAD_LIB = ${PTHREAD_LIB}")
 # FIXME : check for existing header in that directory
include_directories(${SCOTCH_INCLUDE_PATH}) 

# SCALAPACK config
find_library(SCALAPACK_LIB NAMES scalapack scalapack-openmpi HINTS ${SCALAPACK_LIB_DIR})
message(STATUS "SCALAPACK_LIB = ${SCALAPACK_LIB}")

# BLAS config
find_library(BLAS_LIB NAMES openblas blas HINTS ${BLAS_LIB_DIR})
message(STATUS "BLAS_LIB = ${BLAS_LIB}")

# LAPACK config
find_library(LAPACK_LIB NAMES lapack HINTS ${LAPACK_LIB_DIR})
message(STATUS "LAPACK_LIB = ${LAPACK_LIB}")

# OpenMP
find_package(OpenMP)

if (OpenMP_Fortran_FOUND) ## Beware : we have to deal with old versions of cmake for which this variable is not defined !!!
    message(STATUS "OpenMP Found")
    message(STATUS "OpenMP LIBRARIES = ${OpenMP_Fortran_LIBRARIES}")
    message(STATUS "OpenMP FLAG =  ${OpenMP_Fortran_FLAGS}")
    add_definitions("-DOPENMP ${OpenMP_Fortran_FLAGS}")
    set(OMP_LIB ${OpenMP_Fortran_LIBRARIES})
    if (OpenMP_Fortran_HAVE_OMPLIB_HEADER)
        message(STATUS "has a OMPLIB_HEADER")
    endif()
    if (OpenMP_Fortran_HAVE_OMPLIB_MODULE)
        message(STATUS "has a OMPLIB_MODULE")
        message(STATUS "OMP_LIB =${OpenMP_Fortran_LIBRARIES}")
    endif()
endif(OpenMP_Fortran_FOUND)

add_executable (simple_test zsimpletest.F90)
target_link_libraries (simple_test  ${MUMPS_LIB} ${MUMPS_COMMON_LIBRARY} ${MUMPS_PORD_LIBRARY} ${SCOTCH_LIB} ${SCALAPACK_LIB} ${LAPACK_LIB} ${BLAS_LIB} ${MPI_Fortran_LIBRARIES} ${OpenMP_Fortran_LIBRARIES}) 
