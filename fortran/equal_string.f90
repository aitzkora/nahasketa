program zutos
  use iso_fortran_env
  use iso_c_binding
  implicit none
  character(:), allocatable :: x
  character(len=12), allocatable :: y
  x = "jej"
  y = "jej"
  print *, x == y
  print *, len(y)
  print *, len(x)
end program zutos
