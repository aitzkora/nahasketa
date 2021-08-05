program test_io
  integer, allocatable :: tab1(:,:), tab2(:,:)
  integer, allocatable :: v1(:), v2(:)
  integer :: m, n
  tab1 = reshape([(i,i=1,12)],[3, 4])
  open(33, file="one_matrix.txt", action="write")
  write(33,*) size(tab1,1), size(tab1, 2)
  write(33,*) tab1
  close(33)

  open(12, file="one_matrix.txt", action="read")
  read(12,*) m, n
  print *, "m = ", m, " n = ", n
  allocate(tab2(m,n))
  read(12,*) tab2
  close(12)
  if (any(tab1 /= tab2)) then
      print *, "il y a un probleme"
  else
      print *, "pas de pb", sum(tab1-tab2)
  end if

  v1 = [(i,i=12,1,-1)]
  open(33, file="one_vect.txt", action="write", form="unformatted")
  write(33) size(v1) 
  write(33) v1
  close(33)

  open(12, file="one_vect.txt", action="read", form="unformatted")
  read(12) m
  print *, "m = ",m
  allocate(v2(m))
  read(12) v2
  close(12)
 
  if (any(v1 /= v2)) then
      print *, "il y a un probleme"
  else
      print *, "pas de pb", sum(v1-v2)
  end if


end program
