module bidon
   implicit none
contains
   function my_size(t)
    integer :: my_size
    integer, intent(in) :: t(:)
    my_size = size(t, 1)

   end function

   function get_pi()
   real :: get_pi
     get_pi = 4.*atan(1.0)
   end function

end module bidon
program t
  use bidon
  use iso_fortran_env
  implicit none
  integer :: i, s
  integer , allocatable :: a(:)
    
  s = 0
  do i=1,0
    s = s + i
  end do

  print *, s
  a=  [1, 2, 3]
  print *, my_size(a)

end program
