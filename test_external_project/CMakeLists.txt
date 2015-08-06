cmake_minimum_required(VERSION 2.8)
include(ExternalProject)
option(PREFIX "directory where to install packages")
if (NOT PREFIX)
    message(FATAL_ERROR "you must set PREFIX=/path/to/install ")
endif()

# number of threads to compil
if(NOT DEFINED THREADS_COMPIL)
    set(THREADS_COMPIL 1)
endif()

#openmpi
ExternalProject_Add(
            openmpi
            URL http://www.open-mpi.org/software/ompi/v1.8/downloads/openmpi-1.8.8.tar.gz
            UPDATE_COMMAND "" 
            SOURCE_DIR build_openmpi 
            CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${PREFIX}
            BUILD_COMMAND ${CMAKE_MAKE_PROGRAM} -C <BINARY_DIR> -j${THREADS_COMPIL}
            INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} -j${THREADS_COMPIL} install
           ) 

set(ENV{LD_LIBRARY_PATH} "${PREFIX}/lib:$ENV{PATH}")
set(ENV{PATH} "${prefix}/bin:$ENV{PATH}")
# Petsc
ExternalProject_Add(
            Petsc
            URL http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.5.4.tar.gz 
            UPDATE_COMMAND "" 
            SOURCE_DIR build_petsc
            CONFIGURE_COMMAND cd <SOURCE_DIR> && python2 ./configure --prefix=${PREFIX}
            --download-fblaslapack=yes
            --with-mpi-dir=${PREFIX}
            BUILD_COMMAND ${CMAKE_MAKE_PROGRAM} -C <SOURCE_DIR> all 
            INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} -C<SOURCE_DIR> install
            )
ExternalProject_Add_StepDependencies(Petsc install openmpi)
#parmetis
ExternalProject_Add(
            Parmetis
            URL http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-4.0.3.tar.gz
            UPDATE_COMMAND "" 
            SOURCE_DIR build_parmetis 
            CONFIGURE_COMMAND ${CMAKE_MAKE_PROGRAM} -C <SOURCE_DIR> config prefix=${PREFIX}
            BUILD_COMMAND ${CMAKE_MAKE_PROGRAM} -C <SOURCE_DIR> -j${THREADS_COMPIL}
  ) 
ExternalProject_Add_StepDependencies(Parmetis install openmpi)
