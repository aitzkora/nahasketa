program var_inter
  implicit none
  real, allocatable :: a(:)
  integer, parameter :: STRIP = 4
  integer :: m, i, nstrip
  m = STRIP * 100
  allocate(a(m))
  nstrip = m / STRIP
  a = 1.
  do i=1,nstrip
    block 
      integer :: istart
      istart = 1 + (i-1)*STRIP
      call do_inter(a(istart:istart+STRIP-1))
    end block
  end do
  print *, a(1)
  deallocate(a)
contains 

   subroutine do_inter(a_strip)
     real, intent(inout) :: a_strip(STRIP)
     integer :: i
     do i=1,STRIP
       a_strip(i) = cos(1. + a_strip(i))
     end do
   end subroutine do_inter


end program var_inter
