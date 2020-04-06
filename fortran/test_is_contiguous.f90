program test
      integer :: a(10)
      a = [1,2,3,4,5,6,7,8,9,10]
      call sub (a)      ! every element, is contiguous
      call sub (a(::2)) ! every other element, is noncontiguous
contains
      subroutine sub (x)
          integer :: x(:)
          if (is_contiguous (x)) then
              write (*,*) 'X is contiguous'
          else
              write (*,*) 'X is not contiguous'
          end if
      end subroutine sub 
end program test
