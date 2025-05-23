program var_inter
  implicit none
  real, allocatable :: a(:,:)
  integer, parameter :: STRIP_M = 4, STRIP_N = 8
  integer :: m,n, i, j, nstrip_m, nstrip_n
  m = STRIP_M * 100
  n = STRIP_N * 10
  allocate(a(m,n))
  nstrip_m = m / STRIP_M
  nstrip_n = n / STRIP_N

  a = 1.
  do j=1,nstrip_n
    do i=1,nstrip_m
      block 
        integer :: istart,jstart
        istart = 1 + (i-1)*STRIP_M
        jstart = 1 + (j-1)*STRIP_N
        call do_inter(a(istart:istart+STRIP_M-1,jstart:jstart+STRIP_N-1))
      end block
    end do
  end do
  print *, a(1,1)
  deallocate(a)
contains 

   subroutine do_inter(a_strip)
     real, intent(inout) :: a_strip(STRIP_M, STRIP_N)
     integer :: i,j
     do j=1,STRIP_N
       do i=1,STRIP_M
         a_strip(i,j) = cos(1. + a_strip(i,j))
       end do
     end do 
   end subroutine do_inter


end program var_inter
