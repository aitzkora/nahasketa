program zutos
  use iso_fortran_env
  use iso_c_binding
  implicit none
  integer, parameter :: k4  =  selected_int_kind(ceiling(log(2.**(3*8))/log(10.)))
  integer, parameter :: k8  = selected_int_kind(ceiling(log(2.**(7*8))/log(10.)))
  print *, k4, k8
end program zutos
