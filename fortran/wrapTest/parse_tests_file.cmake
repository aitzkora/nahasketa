#=============================================================
# parse_tests_file
#=============================================================

macro(parse_tests_file filename)

    # write the header of the wrapper file
    get_filename_component(filename_we  ${filename} NAME_WLE)
    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/${filename_we}_wrap.F90 
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
      file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/${filename_we}_wrap.F90 
"        case('${suite_name}')
              call test_${suite_name}
")
           #  message(STATUS "${suite_name}")
      endforeach()
    endforeach()
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/${filename_we}_wrap.F90 
"        case default
     end select
end program ${filename_we}_wrap")
endmacro(parse_tests_file)
