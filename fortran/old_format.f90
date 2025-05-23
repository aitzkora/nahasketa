program 

  real*8   

contains
  subroutine sommme(n, x, s)
    integer :: n
    real*8 ::x(n)
    real*8 ::s
    integer*4 i
    s = 0
    do i=1,n
      s = s + x(i)
    end do
  end subroutine somme

end program
