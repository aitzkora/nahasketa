program zutos
  implicit none
  integer :: i
  integer, allocatable :: a(:,:)
  a = reshape([(i,i=1,2*3)], [2,3])
  print *, sum1(a(1,:))
  print *, sum1(a(:,1))
contains
   
   integer function sum1(t) result(s)
     integer, contiguous :: t(:)
     s = 1 + sum(t)
   end function sum1
  
  end program zutos
