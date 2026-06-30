program zutos
  integer, allocatable :: a(:)
  integer ::i 
  a = [(i, i=1,21)]
  write (*, '(*(g0,:,","))') a
end program zutos
