program char_defer
    use iso_fortran_env
    character(:), allocatable :: arg_defer
    character(len=25) ::  arg_limit
    integer :: status

    call get_command_argument(1, arg_limit)
    print *, arg_defer
    call execute_command_line(arg_limit, exitstat=status)
    print *, 'status = ', status
end program char_defer
