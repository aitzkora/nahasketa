program zutos
  use iso_fortran_env
  use iso_c_binding
  implicit none
  integer i
  integer, allocatable :: a(:,:)
  a = transpose(reshape([1,2,3,&
                         4,5,6], [3,2]))
  do i=1,2
     print '(3(i0,1x))', a(i,:)
  end do
end program zutos
