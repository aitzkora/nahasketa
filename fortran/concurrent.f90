program z
    integer, parameter :: i8 = selected_int_kind(8)
    integer(kind=i8) :: s  = 0
    do concurrent(i=1:10000000)
      s = s + i
    end do
    print *, s
end program
