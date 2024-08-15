cmake_minimum_required(VERSION 3.11 FATAL_ERROR)

project(test_fetch LANGUAGES C)

include(FetchContent)

FetchContent_Declare(
scotch
GIT_REPOSITORY https://gitlab.inria.fr/scotch/scotch.git
GIT_TAG        v7.0.5
CMAKE_ARGS "-DBUILD_PTSCOTCH=OFF"
PATCH_COMMAND patch -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/rustine
)

FetchContent_MakeAvailable(scotch)

add_executable(use_scotch use_scotch.c)
target_link_libraries(use_scotch scotch)
