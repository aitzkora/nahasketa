program zut
  integer, parameter :: dp = selected_real_kind(8)
  real(kind=dp), allocatable :: a(:)
  integer :: i
  a = [(i * 1.d0, i =1, 100)]
  print *, storage_size(a)
end program zut
