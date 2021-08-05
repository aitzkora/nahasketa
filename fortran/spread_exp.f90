program zutos
  integer , allocatable :: a(:)
  a = [1,2,3]
  print '(2(3(1xi0)/))', spread(a, 2, 2)
  print '(3(2(1xi0)/))', reshape(spread(a, 1, 2),[3, 2])
end program zutos
