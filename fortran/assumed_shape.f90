program zutos
 integer, dimension(:,:), allocatable :: a
 integer :: i
 allocate( a(2, 2))
 call un(a)
 print *, a
 deallocate(a)
contains

 subroutine un(u)
    integer, dimension(:,:) , intent(inout) :: u
    call deux(u)
 end subroutine un

 subroutine deux(u)
    integer, dimension(:,:) , intent(inout) :: u
     print *, 'size dans deux', size(u,1)
     u = 1
 end subroutine deux

end program zutos
