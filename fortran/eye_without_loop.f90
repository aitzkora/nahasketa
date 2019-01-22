program eye_without_loop
   implicit none
   real, allocatable :: a(:,:)
   integer :: i, j
   print *, delta( 3, 4)
contains
    pure function delta( m, n )
        integer, intent(in) :: m, n
        real, intent(out):: delta(m, n)
        delta = reshape(merge(1., 0., [((i == j, i=1,m), j=1,n)]), [m,n])
    end function delta
end program eye_without_loop
