program loop
    integer, parameter :: N = 1000000000
    real(kind=8) :: s
    integer :: i
    s =  0
    do i=1, N
       s = s + i
    end do
    print *, s
end program loop
