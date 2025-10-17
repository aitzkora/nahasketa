program test_fdopen
  use iso_c_binding
  use iso_fortran_env
#ifdef __intel__ 
  use ifposix
#endif
  implicit none
#ifdef __NVCOMPILER
  include 'lib3f.h'
#endif

  integer :: fdesc
  type(c_ptr) :: fp
  integer(c_int) :: first, ierr, written
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
     integer(c_int) :: fputs
     character(kind=c_char), dimension(*) :: buf
     type (c_ptr), value :: handle
   end function

  end interface
  
  call execute_command_line("echo coucou > haha.txt")
  mode = "w" // char(0)
#ifdef __INTEL_COMPILER
   call pxffileno(output_unit, fdesc, ierr)
   !call pxffdopen(fdesc, output_unit, 'w', ierr)
   !call pxfwrite(fdesc, "cucu"//achar(13), 5, written, ierr)
   !call pxffputc(output_unit,'c', ierr)
   !call pxffputc(output_unit, 'u', ierr)
   fp = fdopenf(fdesc, mode)
   first = fputs("coco" // c_null_char, fp)  
   write (output_unit, "(a)", advance="no") "cucu"
   !call pxffflush(output_unit, ierr)
   flush(output_unit)
#else
#ifdef __GFORTRAN__
  fdesc = fnum(output_unit)
#elif __NVCOMPILER
   fdesc = getfd(output_unit)
#endif
  fp = fdopenf(fdesc, mode)
  first = fputs("coco" // c_null_char, fp)  
  write (output_unit, "(a)", advance="no") "cucu"
  flush(output_unit)
#endif 
end program test_fdopen
