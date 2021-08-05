program cmp
 
  complex(8), allocatable :: tab(:)
  integer :: i
  tab =  [(cmplx(i*1.d0,-i*1.d0,8), i=1,10)]
  print *, aimag(tab)


end program cmp
