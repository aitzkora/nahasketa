module m_call_back
  use iso_c_binding , only : c_double, c_int64_t, c_char, c_size_t
  implicit none
  private
  public :: trapz, implicite, f, g

contains

   pure function implicite(t) result(x)
    real(c_double), intent(in)  :: t
    real(c_double) :: x, F
    x = 0_c_double
    F = 4.d0 * sin( x ) - exp( x ) + t
    do 
      if (abs( F ) <= 1.d-15) exit
      x = x - F/(4.d0*cos( x ) - exp( x ))
      F = 4.d0 * sin( x ) - exp( x ) + t
    end do
  end function implicite

  pure function trapz(a, b, n, f) result(sum_f)
   implicit none
   real(c_double), intent(in) :: a, b
   integer, intent(in) :: n
   interface
     real(c_double) pure function f(x)
       import :: c_double
       real(c_double), intent(in) :: x
     end function f
   end interface
   real(c_double) :: sum_f, h
   integer :: i
   h = (b - a) / n
   sum_f = 0.5d0 * (f( a ) + f( b ))
   do concurrent (i=1:n-1)
     sum_f = sum_f + f( i * h)
   end do 
   sum_f = sum_f * h
  end function trapz

  pure function f(x) result(y)
    real(c_double), intent(in) :: x
    real(c_double) :: y
    y = exp(-x)*x*x
  end function f

  pure function g(x) result (y)
    real(c_double), intent(in) :: x
    real(c_double) :: y, h
    h = 0.d0
    if (x < 0.5d0) then
      h = -exp( -x )
    else
      h = exp( x )
    end if
    y = h * x**2
  end function g

end module m_call_back
