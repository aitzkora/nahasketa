program test
    integer :: val
    val = this_image ()
    call co_sum (val)
    if (this_image() == 1) then
        write(*,*) "The sum is ", val 
    end if
end program test
