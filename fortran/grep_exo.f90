program grep
  implicit none
  integer :: i, narg, unit_read=65, ios
  character(len=80):: param, command, pattern, filename
  character(len=200) :: current_line

  narg = command_argument_count()
  if (narg < 2) then
      call get_command_argument( 0, param)
      print *, trim(param) // " pattern filename"
      stop
  end if
  call get_command_argument( 1, pattern)
  call get_command_argument( 2, filename)

  open(unit=unit_read, file= filename, iostat=ios)
  if ( ios /= 0 ) stop "cannot open "// trim(filename)
  i = 1
  do
      read(unit_read, '(A)', iostat=ios) current_line
      if (index(current_line, trim(pattern)) /= 0) then 
          print '(i0A)', i, ":"//current_line
      endif
      if (ios /= 0) exit
      i = i + 1
  end do
  close( unit_read )

 contains
pure function put_in_pink(str) result(str_pink)
     character(len=60), intent(in) :: str
     character(*) :: str_pink
     end function



end program grep
