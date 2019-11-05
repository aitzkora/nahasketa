#=============================================================
# parse_tests_file
#=============================================================

macro(parse_tests_file filename)
    get_filename_component(filename_we  ${filename} NAME_WLE)
    set(file_wrap ${CMAKE_CURRENT_BINARY_DIR}/${filename_we}_wrap.F90)
    # write the header of the wrapper file
    file(WRITE  ${file_wrap}
"program ${filename_we}_wrap 
    use iso_fortran_env
    use ${filename_we}
    character(len=256) :: first_arg

    call get_command_argument(1, first_arg)

    select case( trim(first_arg))
")

    
    # now parse the sources to add the tests from each file
    file(READ "${filename}" contents)
    string(REPLACE "\n" ";" rows ${contents})
    foreach(line ${rows})
      string(REGEX MATCHALL "^ *subroutine *test_([A-Za-z_0-9])+ *" found_suite ${line})
      string(REGEX REPLACE "^ *subroutine *test_(([A-Za-z_0-9])+) *" "\\1" suite_name "${found_suite}")
      foreach(i ${suite_name})
      file(APPEND ${file_wrap}
"        case('${suite_name}')
              call test_${suite_name}
")
      set(test_names ${test_names} ${suite_name})
      endforeach()
    endforeach()
    # write the end of the wrapper
    file(APPEND ${file_wrap}
"        case default
     end select
end program ${filename_we}_wrap")
add_executable(${filename_we} ${filename_we}_wrap.F90 ${filename} m_asserts.f90)
message(STATUS "test_names  = ${test_names}")
enable_testing()
foreach(name ${test_names})
    add_test(NAME ${name}  COMMAND ${filename_we} ${name})
endforeach()
endmacro(parse_tests_file)
