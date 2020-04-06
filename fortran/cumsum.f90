program zutos
    use iso_c_binding
    print *, [0.d0, cumsum(1.d0*[1,2,3])]
contains

    pure function cumsum(x) result(y)
        implicit none
        real(c_double), intent(in) :: x(:)
        real(c_double) :: y(size(x,1))
        integer :: i
        y(1) = x(1)
        do i =2, size(x, 1)
           y(i) = y(i-1) + x(i)
        end do

    end function cumsum

end program zutos
