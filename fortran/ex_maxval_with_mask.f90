program zutos
  real, allocatable, dimension(:,:) :: a
  integer :: i, j
  logical, allocatable, dimension(:,:) :: bool
  i = repeat
  a = reshape([(1.*i, i=1,9)], [3, 3])
  bool= reshape([((i/=j, i=1,3),j=1,3)], [3,3])
  print*, maxval(a, bool)

end program zutos
