program hehe
   implicit none
   external dpotrf
   integer, parameter :: n = 3
   integer :: i,j, info
   real(kind=8), dimension(n,n) :: H
   real(kind=8), dimension(n) :: x, b
   forall(i=1:n, j=1:n)
       H(i,j) = 1/(i+j-1.)
   end forall
   print *
   do i=1,n
      print '(10f10.5)', H(i,:)
   end do

   b(:) = 1.d0

   call dpotrf( 'U', n, H, n, info)

   print *, "après factorization"
   do i=1,n
      print '(10f10.5)', H(i,:)
   end do


end program hehe

