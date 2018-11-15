macro(CHECK_KIND_SIZE_IS_SUPPORTED  KIND_SIZE VARIABLE)
    if(NOT DEFINED ${VARIABLE})
#if(${KIND_SIZE}" NOT MATCHES )
    #    message(FATAL_ERROR "KIND_SIZE must be a positive number")
    #endif()
 file(WRITE
    ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testKind${KIND_SIZE}.f90
    "
      program TESTFortran
      implicit none
      intrinsic selected_real_kind
      integer, parameter :: result = selected_real_kind(${KIND_SIZE})
      end program TESTFortran
    "
    )
    try_compile(${VARIABLE}
    ${CMAKE_BINARY_DIR}
    ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testKind${KIND_SIZE}.f90
    OUTPUT_VARIABLE OUTPUT
    )
message(STATUS "out = ${OUTPUT}")
#if(${VARIABLE})
#      set(${VARIABLE} 1 CACHE INTERNAL "Have Fortran function ${FUNCTION}")
#      message(STATUS "Looking for Fortran ${FUNCTION} - found")
#      file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
#        "Determining if the Fortran ${FUNCTION} exists passed with the following output:\n"
#        "${OUTPUT}\n\n")
#    else()
#      message(STATUS "Looking for Fortran ${FUNCTION} - not found")
#      set(${VARIABLE} "" CACHE INTERNAL "Have Fortran function ${FUNCTION}")
#      file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
#        "Determining if the Fortran ${FUNCTION} exists failed with the following output:\n"
#        "${OUTPUT}\n\n")
#    endif()
  endif()
endmacro()
