program coucou
  implicit none
  integer, parameter :: line_max = 1024
  character(len=line_max) :: line
  integer :: nb_enregistrement, hehe, ios, i
  !open(22, action='read', file="hehe.txt")
  !read(22,'(a)') line
  !print *, line
  !close(22)
  !nb_enregistrement = 0
  !do 
  !  read(line,'(i3)', end=1, iostat=ios, advance='no') hehe
  !  nb_enregistrement = nb_enregistrement + 1
  !  print *, "coucou", hehe, nb_enregistrement
  !  if (ios /=0  .or. nb_enregistrement > 10) exit
  !end do
  !1 continue
  !print *, nb_enregistrement
  open(22, action='read', file ='hehe.txt', access = 'stream', form='formatted')
  i = 0
  do 
    read(22, '(i3,1x)', iostat = ios) hehe
    print *, hehe
    i = i + 1
    if (ios /= 0 .or. i > 10) exit
  end do
  print *, i 
end program coucou
