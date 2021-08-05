module m_normal
   use iso_c_binding
   public:: normal
contains
    pure function normal(v) result(n)
      real(c_double), intent(in) :: v(2)
      real(c_double) :: n(2)
      n(1)=v(2)
      n(2)=-v(1)
      n(:)=n(:)/sqrt(sum(n(:)**2))
    end function
end module m_normal


program test_norm
   use m_normal
   implicit none
   real(c_double), allocatable :: a(:), b(:)
   a = [1, 1] * 1.d0
   b = normal(a)
   print *,b
end program 

