program call_back
  use iso_c_binding, only : c_char, c_double
  use m_utils, only : host, MAX_HOSTNAME_LEN, clock
  use m_call_back , only : trapz, implicite, f, g
  implicit none
  integer, parameter :: loops = 10000
  integer :: i
  real(c_double) :: t0 , sum_t, t2
  character(len=MAX_HOSTNAME_LEN,kind=c_char) :: hostname

  hostname = host()
  print '(aa)', "hostname:", hostname
  open(unit = 42, file="../RunningOn" // hostname)
  
  t0 = clock()
  do concurrent(i=1:loops)
    sum_t = trapz(0.d0, 1.d0, 1000, f)
  end do 
  t2 = (clock() - t0) / loops
  print '(a,es0.7)', 'f, computing time:', t2
  print '(es0.7)', sum_t
  write(42,'(a,1x,es0.7)') "f:", t2
  t0 = clock()
  do concurrent(i=1:loops)
    sum_t = trapz(0.d0, 1.d0, 1000, g)
  end do 
  t2 = (clock() - t0) / loops
  print '(a,es0.7)', 'g, computing time:', t2
  print '(es0.7)', sum_t
  write(42,'(a,1x,es0.7)') "g:", t2
  ! implicit
  t0 = clock()
  do concurrent(i=1:loops)
    sum_t = trapz(0.d0, 1.d0, 1000, implicite)
  end do 
  t2 = (clock() - t0) / loops
  print '(a,es0.7)', 'implicit, computing time:', t2
  print '(es0.7)', sum_t
  write(42,'(a,1x,es0.7)') "implicit:", t2

  close(42)
end program call_back
