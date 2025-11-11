program test_sixel
  use m_gray_image
  implicit none

  type(gray_img) :: img
  integer, parameter :: NB_REPEATS = 2
  integer :: i, j, k, l, m, n
  m = 400
  n = 200
  call img%init(m,n)
  do l=1, NB_REPEATS
    do k=1,floor(m/sqrt(2.))
      do j=1, n
        do i=1, m
          img%buff(i,j) = char(min(255, floor(sqrt(1.*(i-m/2)**2+(j-n/2)**2)/k*2)))
        end do
      end do
      call img%render()
      call usleepf(5000)
    end do 
  end do

end program test_sixel
