module m_collectives
    use iso_c_binding
    implicit none
    public :: root_to_all0
contains 

   real(c_double) root_to_all0(x, root) result(s)
       implicit none
       real(c_double), intent(in) :: x
       integer, optional, intent(in) :: root
       real(c_double), allocatable :: y[:]
       integer :: l, me, p
      
       p = num_images()
       me = this_image()
       allocate(y[*])

       if (present(root)) then
           if (me == root) y[i] = x
       else
           if (me == 1) y = x
       end if
       sync all
       l = 1
       do while(l < p)
          l = 2 * l
       end do
       do while (l > 0)
          if (me + l <= p .and. mod( me - 1, 2 * l ) == 0) y[me + l ] = y
          l =  l / 2
          sync all
       end do
       s = y
   end function root_to_all0


end module m_collectives
