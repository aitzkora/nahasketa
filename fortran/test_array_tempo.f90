program test_tempo
  implicit none
  integer, parameter :: dp = selected_real_kind(15,307)
  type :: array_real_ptr
    real(dp), pointer :: p(:)
  end type
  integer :: i
  real(kind=dp), allocatable, target :: t1(:), t2(:)
  type(array_real_ptr) :: t(2)
  t1 = [(1.d0*i, i=1,1000)]
  t2 = spread(2, dim=1, ncopies=1000)
  t(1) % p => t1
  t(2) % p => t2
  print *, compute_something(t)
contains


  function compute_something(tab) result(s)
    type(array_real_ptr) :: tab(:)
    real(kind=dp) :: s 
    integer :: n,j 
    n = size(tab, 1)
    s = 0
    do concurrent(j=1:n)
      s = s + sum((1.d0 - tab(j) % p)**2)
    end do 

  end function compute_something
end program test_tempo
