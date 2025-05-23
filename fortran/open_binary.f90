program read_binary
  use iso_fortran_env
  use iso_c_binding
  implicit none
  integer :: arg_num, nb_bytes
  character(512) :: filename, cmdstr
  character(15) :: numstr
  real(c_float), allocatable:: vec(:)
  arg_num = command_argument_count ( )

  !
  !  Get the filename prefix.
  !
  if ( arg_num  <  1 ) then
    call get_command_argument ( 0, cmdstr )
    print '(a,1x,a)', "usage : ", cmdstr, " filename"
    stop -1
  end if
  call get_command_argument ( 1, filename )

  call get_command_argument ( 2, numstr )
  read (numstr,'(i4)') nb_bytes
  print * , "we will read ", nb_bytes, " bytes"
  allocate(vec(nb_bytes))
  open(unit=22, file=filename, action="read", access="stream", form="unformatted" )
  read (22) vec
  close(22)
  
  print *, vec(1), vec(nb_bytes)


end program read_binary
