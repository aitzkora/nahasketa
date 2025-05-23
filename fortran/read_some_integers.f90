program read_some
  implicit none
  character(len=1024) :: line 
  open (22, file= "test.txt")
  read (22, '(a)') line
  print *, line
  flush (6)
  print *, read_vector(line)
  close (22)
contains

  integer function read_vector(line) result(res)
   character(len=1024), intent(in) :: line
   integer, allocatable :: x(:)
   integer :: i, nb, ios
   i = 0
   ios = 0
   do 
     if (ios < 0) exit
     read (line, '(i1)' ,iostat=ios, err=110) nb 
     print *, i
     i = i + 1
110 end do
   nb = i

  end function read_vector
   
end program read_some
