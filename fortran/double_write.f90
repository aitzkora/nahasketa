program double_write
  integer :: io_unit
  integer :: tab(2), tab2(2)
  io_unit = 22
  tab = [1, 2]
  tab2 = [3, 4]

  open(io_unit,file='Newfile.bin',action='write',form='unformatted', &
     access='stream', status='replace')
  write (io_unit) tab(:)
  close(io_unit)
  call execute_command_line("xxd Newfile.bin")
  print *, "reopen file"
  open(io_unit,file='Newfile.bin',action='write',form='unformatted', &
     access='stream', position='append')
  write (io_unit) tab2(:)
  close(io_unit)
  call execute_command_line("xxd Newfile.bin")
end  program
