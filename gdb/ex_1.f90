program ex_1
  implicit none
  integer :: i
  print *, id([(i,i=1,5)])

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

  pure function id(x) result(z)
    integer, intent(in) :: x(:)
    integer, allocatable :: y(:)
    integer :: z(x(size(x,1)))
    y = [0, cumsum(x) ]
    z = y(2:size(y,1))-x(1:size(y,1)-1)
  end function

end program ex_1

