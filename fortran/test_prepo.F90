program boucleDo
#ifdef OPENMP
use omp_lib
#endif
integer :: i
do i=0, 40
#ifdef OPENMP
   print *, omp_get_thread_num(), "traite", i
#else
   print *, 1, "traite", i
#endif
end do
end program boucleDo
