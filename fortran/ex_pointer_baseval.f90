program zutos
  use iso_fortran_env
  use iso_c_binding
  implicit none
  integer, allocatable  :: a(:)
  
  a = [1,2,3]
  call do_something_shift(a, 3, 1, disp)

contains 
  subroutine do_something_shift(x, n, baseval, f)
    integer, target, intent(in) :: x(*)
    integer, intent(in) :: baseval,n
    external :: f
    integer, pointer :: y(:)
    integer :: i, nnd
    nnd = n+baseval-1
    y(baseval:n+baseval-1) => x(1:n)
    do i = baseval, n+baseval-1
       call f(y(i)) 
    end do
  end subroutine do_something_shift

  subroutine disp(x)
    integer :: x
    print *, x+1.
  end subroutine disp

end program zutos
