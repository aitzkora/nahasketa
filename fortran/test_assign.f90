program data_type_copy
  use iso_c_binding
  implicit none
  type :: my_dt
    integer, allocatable :: a(:)
    integer, pointer :: b(:)
    integer :: c
  end type
  integer :: i
  type(my_dt) :: dt1, dt2
  integer, target :: p(2)  = [1,2]
  dt1 = my_dt([(i, i=1,3)], p, 3)
  dt2 = dt1
  print *, dt1%a, " | " ,dt1%b, " | ", dt1%c
  print *, dt2%a, " | " ,dt2%b, " | ", dt2%c
  dt2%a = 100
  print *, dt2%a
  print *, dt2%b
end program data_type_copy
