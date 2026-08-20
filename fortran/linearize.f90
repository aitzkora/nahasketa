program linearize
  implicit none
  integer, allocatable :: a(:,:)
  integer, parameter :: N = 2
  integer :: i
  allocate(a(2, N*N))
  a(1,:) = [(spread(i, 1, N),i=1,N)]
  a(2,:) = pack(spread([(i,i=1,N)], 2, N),.true.)
  call print(a)
  contains
  subroutine print(a)
    integer, intent(in) :: a(:,:)
    integer :: i,j
    do i =1, size(a, 1)
      do j = 1, size(a,2)
        write (*,"(i0,1x)",advance="no") a(i,j)
      end do
      write (*, "(/)", advance="no")
    end do

  end subroutine print

end program linearize
