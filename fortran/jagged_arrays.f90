module jagged_array
    type jagged
    integer, allocatable :: ints(:)
  end type jagged
  type(jagged), allocatable :: array(:)
  interface assignment (=)
    module procedure affects_jagged
  end interface
contains
  subroutine affects_jagged(j1, j2)
      type(jagged), intent(out) :: j1
      integer, intent(in) :: j2(:)
      j1%ints = j2
  end subroutine

end module jagged_array
program test_jagged
  use jagged_array
  implicit none
  integer :: i, j
  allocate(array(3))
  do i=1,size(array,1)
    allocate(array(i)%ints(i+1))
    array(i)=[(j, j=1,i+1)]
  end do
  do i=1,size(array,1)
     print *, array(i)%ints
  end do

end program test_jagged
