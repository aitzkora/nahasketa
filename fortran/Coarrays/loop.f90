program loop
    integer, parameter :: N = 1000000000
    real(kind=8) :: s[*], accu
    integer :: i, ind(2)
    ind = tile(N)
    s =  0
    do i=ind(1), ind(2)
    s = s + i
    end do
    !print '(i0ai0ai0aE7.2)', this_image(), " → [", ind(1), ",", ind(2), "] = ", s
    sync all
    if (this_image() == 1) then
        accu = s
        do i=2, num_images()
            accu  = accu + s[i]
        end do
        print *, accu
    end if
contains 

    function tile(n) result(s)
        integer, intent(in) :: n
        integer :: s(2)
        integer :: me, p, r, m
        p  = num_images()
        me = this_image()
        r  = mod( n, p )
        m  = (n - 1) / p + 1
        if (r /= 0 .and. me > r) then
           m = m - 1
           s(1) = (me - 1) * m + r + 1
        else
           s(1) = (me - 1) * m + 1
        end if
        s(2) = s(1) + m - 1
    end function tile

end program loop
