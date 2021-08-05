program zutos
  real, allocatable :: a(:,:), b(:,:)
  a = reshape([(1.*i, i=1,6)],[3,2])
  print '(3(2(1xF9.5)/))', transpose(a)
  b = a / spread(sqrt(sum(a**2,dim = 2)), 2, 2)
  print '(3(2(1xF9.5)/))', transpose(b)
  print *, sum(b**2, dim=2)
end program zutos
