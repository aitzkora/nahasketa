program ex_1
  implicit none
  integer :: i
  integer, allocatable :: b(:)
  ! integrate
  b = [0, cumsum([(i,i=1,10)])]
  ! and diff
  print *, b(2:size(b,1))-b(1:size(b,1)-1)
contains

  pure function cumsum(x) result(y)
    integer, intent(in) :: x(:)
    integer :: y(size(x,1))
    integer :: i
    y(1) = x(1)
    do i =2, size(x, 1)
      y(i) = y(i-1) + x(i)
    end do


  end function cumsum
end program ex_1
