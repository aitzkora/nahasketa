program main
  !$ use OMP_LIB
  implicit none
  integer :: rang,a, i
 rang=12
 !$OMP SECTION LASTPRIVATE(rang)
  print*, "hello, mon rang initial est ", rang
  rang = OMP_GET_THREAD_NUM()
  print*, "hello, mon rang est ", rang
 !$OMP END SECTION
  print*, "hello, mon rang final est ", rang
end program main
