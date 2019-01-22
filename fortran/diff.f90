program zutos
    real, dimension(:), allocatable  :: x, y
    integer :: i
    x = [(i*i, i=1, 10)]
    allocate(y, mold= x)
    y(1:size(y)-1) = diff(x)
    print *, y

contains

  pure function diff(x) result(y)
     real, dimension(:), intent(in) :: x
     real, dimension(size(x)-1) :: y
     y(:) = x(2:size(x))-x(1:size(x)-1)
  end function diff

end program zutos
