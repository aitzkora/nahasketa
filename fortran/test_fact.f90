program test_facto
  use iso_fortran_env
  implicit none
  integer, parameter :: dp = real64
  print *, my_int_2(5,5,5) - 1/3705077376.

contains

   function my_int_2(p,q,r)
     integer, intent(in) :: p, q, r
     real(dp) :: my_int_2
     integer :: i
     my_int_2 = gamma( p+1._dp ) * gamma (q+1._dp) / product([(1._dp*i,i=r+1,r+p+q+3)])
   end function

   function my_int(p,q,r)
     integer, intent(in) :: p, q, r
     real(dp) :: my_int, num, den
     integer :: i
     do i = 1,p 
       num = num*j
     end do
     do j = 1, q 
       num = num*j
     end do
     den = r
     do j = r + 1, p+q+r+3
       den = den*j
     end do
     :wQ
   end function

end program test_facto
