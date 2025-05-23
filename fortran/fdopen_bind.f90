program test_fdopen
  use iso_c_binding
  implicit none

  type(c_ptr) :: fp
  integer(c_int) :: first
  character(len=3) :: mode

  interface
   
   function fdopenf(num_desc, mode) bind(C,name="fdopen") result(desc)
    use iso_c_binding
    integer(c_int), intent(in), value  :: num_desc
    character(c_char), intent(in)  :: mode(*)
    type(c_ptr) ::desc
   end function


   function fgetcf(desc) bind(C,name="fgetc") result(one_char)
    use iso_c_binding
    type(c_ptr), intent(in), value :: desc
    integer(c_int) :: one_char
   end function

  end interface
  
   call execute_command_line("echo coucou > haha.txt")
   open(unit=22, file="haha.txt", action="read")
   mode = "r" // char(0)
   fp = fdopenf(fnum(22), mode)
   first = fgetcf(fp)  
   print *, char(first), first
   close(22)

end program test_fdopen
