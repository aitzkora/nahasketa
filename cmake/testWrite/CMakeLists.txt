cmake_minimum_required(VERSION 3.10)
project(cono)
set(MYVAR)
file(WRITE
  ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/cono.cmake
"
file(READ \$ENV{HOME}/.bashrc MYBASHRC)
file(WRITE ${CMAKE_BINARY_DIR}/another_bash \${MYBASHRC})
"
)
add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/another_bash
  COMMAND ${CMAKE_COMMAND} -P ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/cono.cmake
  )
add_custom_target(another DEPENDS ${CMAKE_BINARY_DIR}/another_bash)
