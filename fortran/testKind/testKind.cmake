macro(CHECK_KIND_SIZE_IS_SUPPORTED  KIND_SIZE VARIABLE)
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
      if (.not. result >= 0) then
           print *, 'kind for real of size ${KIND_SIZE} is not supported and has the value = ', result
          stop 2
      else
         print *, 'kind for real of size ${KIND_SIZE} is supported with the value = ', result
      endif
      end program TESTFortran
    "
    )
    try_run(RUN_SUCCESS COMPIL_SUCCESS
    ${CMAKE_BINARY_DIR}
    ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testKind${KIND_SIZE}.f90
    COMPILE_OUTPUT_VARIABLE COMPILE_OUT
    RUN_OUTPUT_VARIABLE RUN_OUT
    )
    if(${COMPIL_SUCCESS})
        if ("${RUN_SUCCESS}" STREQUAL "0")
           message(STATUS "REAL KIND of size ${KIND_SIZE} is supported ")
           set(${VARIABLE} 1 CACHE INTERNAL "KIND ${KIND_SIZE} supported")
           file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
               "Determining if kind of size ${KIND_SIZE} passed with the following output:\n"
           "${RUN_OUT}\n\n")
        else()
          message(STATUS "REAL KIND of sized ${KIND_SIZE} not supported")
          set(${VARIABLE} "" CACHE INTERNAL "KIND ${KIND_SIZE} supported")
          file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
              "Determining if kind of size ${KIND_SIZE} exists failed with the following output:\n"
            "${RUN_OUT}\n\n")
        endif()
    else()
        message(WARNING "Could not compile a simple program for testing which real kinds are supported")
        file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
            "Determining if kind of size ${KIND_SIZE} generated the following output during compilation:\n"
            "${COMPILE_OUT}\n\n")
    endif() # if (${COMPIL_SUCCESS})
endmacro()
