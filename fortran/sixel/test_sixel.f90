program test_sixel
  use m_sixel
  use iso_c_binding
  implicit none
  integer(c_int) :: status

  type(c_ptr) :: output

  status = sixel_output_new(output, sixel_write, fdopenf(fnum(6), "w+" // c_null_char))
  if (status /= 0) then
     stop "can' create ouptut"
  end if

  call sixel_output_destroy(output) 


end program test_sixel
