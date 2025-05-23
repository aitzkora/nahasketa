program zutos

  implicit none
  integer :: i
  integer, allocatable :: a(:,:)
  a = reshape([(i,i=1,2*3)], [2,3])
  call print_dims(a(1,:))
  call print_dims(a(:,1))

  interface print_dims
    procedure :: print_dims_1
  end interface print_dims
 
contains
    
    subroutine print_dims_1(t)
     integer, intent(in) :: t(:)
     integer :: i
     character(32) :: my_format
     print '(a,i0)', "rank = ", rank(t)
     write (my_format, '(a,i0,a)') "(a0,", rank(t), "(i0,1x))"
     print my_format, [(size(t, i), i=1,rank(t))]
   end subroutine print_dims_1
  
end program zutos
