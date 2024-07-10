program test_sixel
  use m_gray_image
  use iso_c_binding
  use iso_fortran_env
  implicit none
  integer(c_int) :: status

  character(c_char), target, allocatable :: buff(:,:)
  integer(c_int) :: i,j,k, m
  type(gray_img) :: img
  m = 400
  allocate(buff(m,m))
  call gray_img_constructor(img)
  do
    do k=1,floor(m/sqrt(2.))
      do i=1, m
        do j=1, m
         buff(i,j) = char(min(255, floor(sqrt(1.*(i-m/2)**2+(j-m/2)**2)/k*2)))
       end do
      end do
      status = img%render(buff)
    end do 
  end do


end program test_sixel
