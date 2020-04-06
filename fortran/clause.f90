program hehe
 
      real :: s_0
      integer :: n,i 
      character(len=32) :: n_str
      call get_command_argument(1, n_str)
      read (*,n_str) n 

      do concurrent(i=1:n) shared(s_0)
           s_0 = s_0 + i 
      end do

      print *, s_0

end program hehe
