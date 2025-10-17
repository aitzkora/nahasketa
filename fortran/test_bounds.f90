program tst_bnds
  implicit none
  integer, allocatable :: a(:)
  a = [1, 2,3]
  print '(a,i0,a,i0,a)', "a(", lbound(a), ":", ubound(a), ")"
  call disp(3, a)
contains 

  subroutine disp(n, x)
    integer, intent(in):: n
    integer :: x(0:n-1)
    integer :: i
    print "(a,i0,a,i0,a)", "inside disp ->a(", lbound(x), ":", ubound(x), ")"
    do i=0, n-1
      print "(i0,1x)", x(i)
    end do
  end subroutine disp
end program tst_bnds
