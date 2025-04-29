      subroutine modify(f, n,x)
      integer*4 n
      real*8 x(n)
      external f
      do i=1,n
        call f(x(i))
      end do
      end subroutine modify
