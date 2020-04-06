program test_ex
  use iso_fortran_env
  character(len=1024) :: chaine

   chaine = "/usr/bin/ls"
   call execute_command_line(trim(adjustl(chaine)))
   
end program test_ex
