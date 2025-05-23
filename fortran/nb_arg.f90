program char_defer
    use iso_fortran_env
    character(:), allocatable :: arg_defer
    character(len=25) ::  arg_limit
    integer :: nb_arg

    nb_arg = command_argument_count()
    print *, "nb_arg = ", nb_arg
    do i = 0, nb_arg 
      call get_command_argument(i, arg_limit)
      print *, arg_limit
    end do
end program char_defer
