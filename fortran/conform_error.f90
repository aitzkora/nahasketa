program conform
  implicit none
  integer :: i
  character(32) :: var_format
  integer, allocatable :: a(:,:), b(:,:), c(:,:)
  a = reshape([(i,i=1,9)], [3,3])
  b = reshape([1,2,3], [1,3])
  c = a - b
  write(var_format,"(a,i0,a,i0,a)") "(",size(c,1), "(", size(c, 2), "(i0,1x)/)))"
  print var_format, c
end program conform
