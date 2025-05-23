program zutos
  use iso_fortran_env
  use iso_c_binding
  implicit none
  integer, allocatable :: a(:), b(:)
  a = [ 1, 2, 3]
  b = [ 4 , 5 ]
  call move_alloc(from=a, to=b)
  print *, b(2)
end program zutos
