program test_dir
   integer ::  ierr, stat
   logical :: ex
#if defined(__INTEL_COMPILER)
   inquire(directory="build", exist=ex)
   print *, ex
   inquire(directory="buildA", exist=ex)
   print *, ex
#else
   inquire(directory="build", exist=ex)
   print *, ex
   inquire(directory="buildA", exist=ex)
   print *, ex
#endif

end program test_dir
