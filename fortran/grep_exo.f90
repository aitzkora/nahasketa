program grep
  implicit none
  integer :: i, narg
  character(len=80):: param, command, pattern, filename

  narg = command_argument_count()
  if (narg < 2) then
      call get_command_argument( 0, param)
      print *, trim(param) // " pattern filename"
      stop
  end if
  call get_command_argument( 1, pattern)

  call get_command_argument( 2, filename)

end program grep
