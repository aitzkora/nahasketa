module compute_tab
  implicit none
  integer, parameter :: sp = selected_real_kind(4, 307)
  integer, parameter :: N_STATIC = 1000
contains 
  pure function f_static(tab) result(accu)
    real(sp), intent(in) :: tab(N_STATIC)
    real(sp):: accu
    integer :: i
    accu = 0
    do concurrent(i=1:N_STATIC)
      accu = accu + cos(1._sp-tab(i)**3)
    end do
  end function f_static

  pure function f_assumed_shape(tab) result(accu)
    real(sp), intent(in) :: tab(:)
    real(sp):: accu
    integer :: i
    accu = 0
    do concurrent(i=1:size(tab,1))
      accu = accu + cos(1._sp-tab(i)**3)
    end do
  end function f_assumed_shape

  pure function f_size_arg(tab, n) result(accu)
    real(sp), intent(in) :: tab(n)
    integer, intent(in) :: n 
    real(sp):: accu
    integer :: i
    accu = 0
    do concurrent(i=1:n)
      accu = accu + cos(1._sp-tab(i)**3)
    end do
  end function f_size_arg
end module compute_tab

program test_perf
  use compute_tab
  implicit none
  integer(8), parameter :: nb_tries = 2000000
  real(sp), allocatable :: tab(:,:)
  integer(8) :: i
  real :: start, finish
  real(sp) :: accu(3)
  allocate(tab(N_STATIC,nb_tries))
  call random_number(tab)

  !premier test
  accu(1) = 0.0_sp
  call cpu_time(start)
  do concurrent(i=1:nb_tries)
    accu(1) = accu(1) + f_static(tab(:,i))
  end do
  call cpu_time(finish)
  print '("Time static = ",f6.3," seconds.")',finish-start

  !2eme test
  accu(2) = 0.0_sp
  call cpu_time(start)
  do concurrent(i=1:nb_tries)
    accu(2) = accu(2) + f_assumed_shape(tab(:,i))
  end do
  call cpu_time(finish)
  print '("Time assumed= ",f6.3," seconds.")',finish-start
  
  !3eme test
  accu(3) = 0.0_sp
  call cpu_time(start)
  do concurrent(i=1:nb_tries)
    accu(3) = accu(3) + f_size_arg(tab(:,i), N_STATIC)
  end do
  call cpu_time(finish)
  print '("Time size arg= ",f6.3," seconds.")',finish-start

  deallocate(tab)

  CHECK : if (norm2(accu / accu(1) - spread(1.0_sp,1,3)) .gt. 1e-6) then
    stop -1
  else
    print *, accu
  end if CHECK

end program test_perf

