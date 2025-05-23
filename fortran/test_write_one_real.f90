program test_write_one_float
  integer, parameter :: dp = selected_real_kind(15,307)
  integer, parameter :: sp = selected_real_kind(4, 307)
  complex(kind=dp):: a
  integer:: io_unit
  io_unit = 22 
  a=cmplx(10.0,0)
  call execute_command_line("rm -f one_float.bin")
  open(io_unit,file='one_float.bin',action='write',form='unformatted', &
    access='stream', status='replace')
  write (io_unit) real(a)
  close(io_unit)
  call execute_command_line("wc --bytes one_float.bin")

end program test_write_one_float
