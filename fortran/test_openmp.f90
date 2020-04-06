program test_openmp
   use omp_lib
   integer :: i
   logical :: flag
   integer :: array(8)
   character(len=256) :: string
   call omp_set_num_threads(4)
   read (*,*) string
   !$omp parallel do
   do i=1, 8
      array(i) = i
   end do
   !$omp end parallel do
   print *, array
end program test_openmp
