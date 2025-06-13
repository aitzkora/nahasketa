cmake_minimum_required (VERSION 3.10)
project(KillMetis)
enable_language(Fortran)

find_package(SCOTCH)

add_executable(dual_and_part.x dual_and_part.f90)
target_link_libraries(dual_and_part.x PRIVATE SCOTCH::scotch)
