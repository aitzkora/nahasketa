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

#=====================================================================================
#OPENMPI
#=====================================================================================
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
set(ENV{PATH} "${PREFIX}/bin:$ENV{PATH}")
#=====================================================================================
# Petsc
#=====================================================================================
ExternalProject_Add(
            Petsc
            URL http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.5.4.tar.gz 
            UPDATE_COMMAND "" 
            CONFIGURE_COMMAND cd <SOURCE_DIR> && python2 ./configure --prefix=${PREFIX}
            --download-fblaslapack=yes
            --with-mpi-dir=${PREFIX}
            BUILD_COMMAND ${CMAKE_MAKE_PROGRAM} -C <SOURCE_DIR> all 
            INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} -C<SOURCE_DIR> install
            )
ExternalProject_Add_StepDependencies(Petsc install openmpi)
#=====================================================================================
#Parmetis
#=====================================================================================

#Awful hack to retrieve the name of directory proposed by
#parmetis makefile . It would be best to use directly the config 
# furnished by by the cmake 
execute_process(COMMAND uname -m OUTPUT_VARIABLE cputype)
execute_process(COMMAND  uname -s OUTPUT_VARIABLE systype)
string(STRIP ${systype} systype)
string(STRIP ${cputype} cputype)
set(BUILDDIR "build/${systype}-${cputype}")
ExternalProject_Add(
            Parmetis
            URL http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-4.0.3.tar.gz
            SOURCE_DIR build_parmetis 
            UPDATE_COMMAND "" 
            PATCH_COMMAND cd metis/include/ && patch < ${CMAKE_SOURCE_DIR}/metis_patch.txt
            CONFIGURE_COMMAND ${CMAKE_MAKE_PROGRAM} -C <SOURCE_DIR> config prefix=${PREFIX}
            BUILD_COMMAND cd <SOURCE_DIR>/${BUILDDIR} && ${CMAKE_MAKE_PROGRAM}
            -j${THREADS_COMPIL} all
            INSTALL_COMMAND cd <SOURCE_DIR>/${BUILDDIR} && ${CMAKE_MAKE_PROGRAM} install 
            ) 
ExternalProject_Add_StepDependencies(Parmetis install openmpi)
ExternalProject_Add_Step(Parmetis copy_metis_lib 
    COMMAND ${CMAKE_COMMAND} -E copy
    <SOURCE_DIR>/${BUILDDIR}/libmetis/libmetis.a ${PREFIX}/lib
    DEPENDEES install
    COMMENT "copy metis.a ${PREFIX}/lib")
ExternalProject_Add_Step(Parmetis copy_metis_include 
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/metis/include/metis.h ${PREFIX}/include
    DEPENDEES install
    COMMENT "copy metis.h into ${PREFIX}/include")
# ===================================================================================n
# HDF5
# =====================================================================================
ExternalProject_Add(
            HDF5 
            URL http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.15-patch1.tar  
            UPDATE_COMMAND "" 
            SOURCE_DIR build_hdf5
            CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${PREFIX}
            --enable-parallel 
            BUILD_COMMAND ${CMAKE_MAKE_PROGRAM} -C <BINARY_DIR> -j${THREADS_COMPIL}
            INSTALL_COMMAND cd <BINARY_DIR> && ${CMAKE_MAKE_PROGRAM} install 
            ) 
ExternalProject_Add_StepDependencies(HDF5 install openmpi)
# ===================================================================================n
# SCOTCH
# =====================================================================================
ExternalProject_Add(
    SCOTCH 
    URL http://gforge.inria.fr/frs/download.php/latestfile/298/scotch_6.0.3.tar.gz
    UPDATE_COMMAND "" 
    SOURCE_DIR build_scotch
    PATCH_COMMAND  patch -p1 < ${CMAKE_SOURCE_DIR}/scotch_patch.txt
    CONFIGURE_COMMAND cd <SOURCE_DIR>/src && ${CMAKE_COMMAND} -DPREFIX=${PREFIX} -P
    configure_scotch.cmake 
    BUILD_COMMAND cd <SOURCE_DIR>/src && ${CMAKE_MAKE_PROGRAM}  -j${THREADS_COMPIL}
    INSTALL_COMMAND cd <SOURCE_DIR> && ${CMAKE_MAKE_PROGRAM} install 
    ) 
ExternalProject_Add_StepDependencies(SCOTCH install openmpi)
