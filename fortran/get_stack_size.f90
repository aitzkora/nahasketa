program  test_omp

   use omp_lib

   implicit none
   integer :: st_size, i, z
   call 
   z= 0
   !$omp parallel do
   do i=1,10
     z = z + i 
   end do
   !$omp end parallel do
   print *,z
end program test_omp
