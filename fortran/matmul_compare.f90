program test_matmul
   implicit none
   integer, parameter  :: nb_tries = 100000
   integer, parameter  :: m = 3
   integer, parameter  :: fp = kind(1.d0)
   real(fp) :: a(m,m), b(m,m), c(m,m)
   real(fp) :: t_start, t_stop
   integer :: i
   a(:,:) = reshape([(i*.1d0,i=1,m*m)], [m,m])
   b = a**2 + 1

   call matmul_mano(a,b,c)
   if (norm2(matmul(a,b)-c) > 1e-12 * norm2(c)) then
     print *, "*****************ERROR****************"
   end if

   call cpu_time(t_start)
   do i=1, nb_tries
        call matmul_mano(a,b,c)
   end do

   call cpu_time(t_stop)
   print *, "mano = ", t_stop - t_start

   call cpu_time(t_start)
   do i=1, nb_tries
        c = matmul(a,b)
   end do

   call cpu_time(t_stop)
   print *, "matmul = ", t_stop - t_start


contains

   subroutine matmul_mano(a,b,c) 
     real(fp), intent(in) :: a(m,m), b(m,m)
     real(fp), intent(out) :: c(m,m)
     integer :: i,j,k

     do concurrent(j=1:m)
       do concurrent(i=1:m)
         c(i,j) = 0._fp
         do concurrent(k=1:m)
           c(i,j) =  c(i,j) + a(i,k) * b(k,j)
         end do
       end do
     end do   

   end subroutine matmul_mano

end program test_matmul
