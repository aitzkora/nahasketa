program zutos
  integer, allocatable :: x(:, :, :)
  integer :: n(3), i
  x = reshape([(i, i=1,27)],[3,3,3])
  n = [(size(x,1), i=1,3)]
  print '(3(i0(1x)))', n
  !print '(3(3(3(i0,1x)/)//))', x
end program zutos
