program hehe
  implicit none
  integer :: iu,  i
  integer :: a(4)
  open ( newunit=iu, file='test.txt', action='read' ) 
  read (iu, *) (a(i),i=1,4)
  print *, a
  close(iu)
end program hehe
