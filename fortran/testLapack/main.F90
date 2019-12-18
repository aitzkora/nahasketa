program compute_hilbert_inverse
   use m_linalg 
   implicit none
   external :: dpotrf , dpotri !FIXME use interface
   integer, parameter :: n = 3
   integer :: i,j
   real(kind=8), allocatable :: H(:,:), H_inv(:,:)
  
   H = 1.d0/ (reshape([((i+j, j=1,n),i=1,n)],[n,n]) - 1.d0)
   H_inv = compute_inv(H)

   print *, "Hilbert de ", n
   call pretty_print(H)

   print *, "après inversion"
   call pretty_print(H_inv)

   print *, "H⁻¹H"
   call pretty_print(matmul(H_inv, H))
 
contains 

end program compute_hilbert_inverse

