program z
 implicit none
 integer, allocatable :: x(:)
 integer :: i

 interface 
   subroutine hehe(x)
     integer, intent(inout) :: x
   end subroutine  hehe
 end interface
   procedure(hehe), pointer  :: p

   p => haha

   i = 2
   call p(i)

contains
   subroutine haha(x)
     integer, intent(inout) :: x
     x = x + 2
     print * , "x = ", x
   end subroutine haha
end program z
