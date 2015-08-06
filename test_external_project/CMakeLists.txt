cmake_minimum_required(VERSION 2.8)
include(ExternalProject)
tion(PREFIX "directory where to install packages")
if (NOT PREFIX)
    message(FATAL_ERROR "you must set PREFIX=/path/to/install ")
endif()

#processor count
if(NOT DEFINED PROCESSOR_COUNT)
    # Unknown:
    set(PROCESSOR_COUNT 0)

    # Linux:
    set(cpuinfo_file "/proc/cpuinfo")
    if(EXISTS "${cpuinfo_file}")
        file(STRINGS "${cpuinfo_file}" procs REGEX "^processor.:
        [0-9]+$")
        list(LENGTH procs PROCESSOR_COUNT)
    endif()

    # Mac:
    if(APPLE)
        find_program(cmd_sys_pro
            "system_profiler")
        if(cmd_sys_pro)
            execute_process(COMMAND
                ${cmd_sys_pro}
                OUTPUT_VARIABLE
                info)
            string(REGEX
                REPLACE
                "^.*Total
                Number Of
                Cores:
                ([0-9]+).*$"
                "\\1"
                PROCESSOR_COUNT
                "${info}")
        endif()
    endif()

    # Windows:
    if(WIN32)
        set(PROCESSOR_COUNT
            "$ENV{NUMBER_OF_PROCESSORS}")
    endif()
endif()

#openmpi
ExternalProject_Add(
            openmpi
            URL http://www.open-mpi.org/software/ompi/v1.8/downloads/openmpi-1.8.8.tar.gz
            UPDATE_COMMAND "" 
            SOURCE_DIR build_openmpi 
            CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix={PREFIX}
            BUILD_COMMAND ${CMAKE_MAKE_PROGRAM} -C <SOURCE_DIR>
            -j{PROCESSOR_COUNT}
            INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} -j{PROCESSOR_COUNT}
           ) 

set(ENV{LD_LIBRARY_PATH} "${PREFIX}/lib:$ENV{PATH}")
set(ENV{PATH} "${prefix}/bin:$ENV{PATH}")
# Petsc
ExternalProject_Add(
            Petsc-3.5.4
            URL http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.5.4.tar.gz 
            UPDATE_COMMAND "" 
            SOURCE_DIR build_petsc
            CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix={PREFIX}
            --download-fblaslapack=yes
            --with-mpi-dir=${PREFIX}
            BUILD_COMMAND ${CMAKE_MAKE_PROGRAM} -C <SOURCE_DIR> -j{PROCESSOR_COUNT}
            )
# parmetis
#ExternalProject_Add(
#            Parmetis-4.0.3
#            URL http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-4.0.3.tar.gz
#            UPDATE_COMMAND "" 
#            SOURCE_DIR build_parmetis 
#            CONFIGURE_COMMAND ${CMAKE_MAKE_PROGRAM} -C <SOURCE_DIR> config prefix=${PREFIX}
#            BUILD_COMMAND ${CMAKE_MAKE_PROGRAM} -C <SOURCE_DIR>
#            -j{PROCESSOR_COUNT}

            ) 
