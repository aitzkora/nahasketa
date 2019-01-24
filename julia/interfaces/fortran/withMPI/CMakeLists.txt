cmake_minimum_required (VERSION 3.0)
project (HeatModernFortran)
enable_language(Fortran)

# Check whether MPI support is available.
find_package(MPI)
if (MPI_FOUND)
  #add_definitions("-Wall -fbounds-check -Werror -Wextra")
  message(STATUS "MPI found")
  include_directories(${MPI_INCLUDE_PATH})
  add_library(heat_solve SHARED heat_solve.f90 communications.f90 heat.f90)
  target_link_libraries(heat_solve ${MPI_Fortran_LIBRARIES})
  install(TARGETS heat_solve DESTINATION ${CMAKE_SOURCE_DIR})
  #add_executable(heat_exe heat_main.f90 heat_solve.f90 communications.f90 heat.f90)
  #target_link_libraries(heat_exe ${MPI_Fortran_LIBRARIES})
  #install(TARGETS heat_exe DESTINATION ${CMAKE_SOURCE_DIR})

  # par_sum example
  add_executable(par_sum par_sum.f90)
  target_link_libraries(par_sum ${MPI_Fortran_LIBRARIES})
  install(TARGETS par_sum DESTINATION ${CMAKE_SOURCE_DIR})

  # reduce bindings example
  add_library(par_sum2 SHARED par_sum2.f90)
  #add_definitions("-Wall -fbounds-check -Werror -Wextra")
  target_link_libraries(par_sum2 ${MPI_Fortran_LIBRARIES})
  install(TARGETS par_sum2 DESTINATION ${CMAKE_SOURCE_DIR})
else(MPI_FOUND)
    message(FATAL_ERROR "MPI not found; you NEED it to compile the project")
endif(MPI_FOUND)
