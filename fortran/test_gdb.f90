program zutos
   integer :: i = 2, j=3
   do i=1,10
      j = i + j
      x = j*j
      y = y + x
   end do 
   print *, y
end program zutos
