program test_fdopen
  use iso_c_binding
  implicit none

  type(c_ptr) :: fp
  integer(c_int) :: first
  character(len=3) :: mode

  interface
   
   function fdopenf(num_desc, mode) bind(C,name="fdopen") result(desc)
    use iso_c_binding
    integer(c_int), value :: num_desc
    character(c_char), intent(in) :: mode(*)
    type(c_ptr) ::desc
   end function

   function fputs(buf, handle) bind(C, name='fputs')
     use iso_c_binding
     integer(c_int) :: system_fputs
     character(kind=c_char), dimension(*) :: buf
     type (c_ptr), value :: handle
   end function

  end interface
  
  call execute_command_line("echo coucou > haha.txt")
  mode = "w" // char(0)
  fp = fdopenf(fnum(6), mode)
  first = fputs("coco" // c_null_char, fp)  
end program test_fdopen
