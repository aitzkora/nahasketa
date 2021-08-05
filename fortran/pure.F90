program t
  use iso_fortran_env
  integer :: i, repeats
  integer, parameter :: n = 1000000
  integer, parameter :: dp = selected_real_kind(15,307)
  real(kind=dp) :: s
  do repeats=1, 10000
  s =  0.d0
#ifndef DEBUG
  do concurrent(i=1:n)
#else
  do i=1,10
#endif
      s = s + i * 1.d0 /n
  end do
  end do
  print *, s

contains 

#ifndef DEBUG
    pure function haha(x) 
#else
    function haha(x) 
#endif
      real(kind=dp), intent(in) :: x
      real(kind=dp) :: haha
#ifdef DEBUG
        if (x < 0) stop -1
#endif
        haha = 1.d0 + erfc(sqrt(x))
end function haha

end program t
