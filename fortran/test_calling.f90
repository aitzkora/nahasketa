program  test_call
  integer, parameter :: dq=16 
  integer:: j=2
  real(dq) :: tab(3) = real([4._dq*atan(1._dq), -exp(1._dq),  -1._dq ], dq)
  
  print * , val(2._dq, [ tab(2:1:-1), exp(-1._dq), tab(j), 0._dq] / 3.)

contains

  function val(p, t) result(z)
   real(dq), intent(in) :: p, t(:)
   real(dq) :: z(size(t))
    z = t + p
  end function
end program test_call
