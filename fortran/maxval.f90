program zutos
  implicit none
  integer, allocatable :: a(:,:)
  a = reshape([1,2,3,4,5,6], [2,3])
  print '(2(3(i0,1x)/))', transpose(a)
  print *, maxval(a,dim=1)
end program zutos
