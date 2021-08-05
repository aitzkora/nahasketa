program zutos
    integer :: i
    real, allocatable :: x(:)
    x = [(1.0*i, i=1,10)]
    print *, f(2.*x+1.) == 1770.
    
contains

    function f(x) result(y)
      real, intent(in) :: x(:)
      real :: y
      y = sum(x**2)
    end function f

end program zutos
