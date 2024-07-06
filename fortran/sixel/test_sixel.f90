program test_sixel
  use m_sixel
  use iso_c_binding
  implicit none
  integer(c_int) :: status

  type(c_ptr) :: output
  !type(sixel_dither) :: dither
  type(c_ptr) :: dither
  type(sixel_dither), pointer :: ditherf
  type(sixel_output), pointer :: outputf
  character(c_char), target, allocatable :: buff(:,:)
  integer(c_int) :: i,j
  status = sixel_output_new(output, sixel_write, fdopenf(fnum(6), "w" // c_null_char))
  if (status /= 0) then
     stop "can't create ouptut"
  end if
  call c_f_pointer(output, outputf)
  
  dither = sixel_dither_get(SIXEL_BUILTIN_G8)
  call c_f_pointer(dither, ditherf)

  call sixel_dither_set_pixelformat(dither, SIXEL_PIXELFORMAT_G8);

  allocate(buff(255,255))
  do i=1, 255
    do j=1, 255
     buff(i,j) = max(char(i),char(j))
   end do
  end do
  status = sixel_encode(c_loc(buff), size(buff,1), size(buff, 2), 0, dither, output)

  call sixel_output_destroy(output) 


end program test_sixel
