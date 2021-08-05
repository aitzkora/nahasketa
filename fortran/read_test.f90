program hehe
  implicit none
  integer :: i
  character(120) :: str(3)

  open(12, file="hehe.txt")
  do i=1, 3
    read(12,'(A)') str(i)
    print *, "ligne", i, "taille = ", len(str(i))
  end do
  close(12)

end program hehe
