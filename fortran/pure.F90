program t
  use iso_fortran_env
  real(kind=8) :: a(10)
  integer :: i
#ifndef DEBUG
  do concurrent(i=1:10)
#else
  do i=1,10
#endif
      a(i) = haha(1.d0 * i)
  end do

  print *, a

contains 

#ifndef DEBUG
    pure function haha(x) 
#else
    function haha(x) 
#endif
      real(kind=8), intent(in) :: x
      real(kind=8) :: haha
#ifdef DEBUG
        if (x < 0) stop -1
#endif
        haha = 1 + sqrt(x)
end function haha

end program t
