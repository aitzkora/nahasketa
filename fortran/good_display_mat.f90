program test_display_mat
  implicit none
  integer, allocatable :: a(:,:)
  integer :: i,j,k
 
  allocate(a(2,3))
  k=1
  do i=1,2
    do j=1,3
      a(i,j)=k
      k=k+1
    end do
  end do
  ! a is [ 1, 2, 3,
  !        4, 5, 6]
  !
  ! but look at the following print
  ! first print in one line, no confuse
  print *,"oneline print"
  print *, a
  ! try with two lines of 3 elements, beware data is store by columuns!
  print *, "bad display-> tranpose(a)"
  write (6,'(2(3(i0,1x)/))',advance='no') a
  ! to print correctly , you need to transpose a
  print *,"good display"
  write (6,'(2(3(i0,1x)/))',advance='no') transpose(a) 
end program test_display_mat
