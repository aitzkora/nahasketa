program zutos

   character(len=192) :: str = "12.5 4.7 2.7"
   real, allocatable :: a(:)
   real :: x
   do i=1,3
   read(str,*,err=1) x
    print *,x
   end do
   1 continue
   !print *,a

end program zutos
