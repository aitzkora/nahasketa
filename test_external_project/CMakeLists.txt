cmake_minimum_required(VERSION 2.8)
include(ExternalProject)
set(PREFIX ${CMAKE_SOURCE_DIR})
ExternalProject_Add(
            Parmetis-4.0.3
            URL http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-4.0.3.tar.gz
            UPDATE_COMMAND "" 
            SOURCE_DIR build_parmetis 
            CONFIGURE_COMMAND ${CMAKE_MAKE_PROGRAM} -C <SOURCE_DIR> config prefix=${PREFIX}
            BUILD_COMMAND ${CMAKE_MAKE_PROGRAM} -C <SOURCE_DIR> 
            ) 
