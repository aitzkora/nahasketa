program test_shift
      implicit none
      integer, dimension(3,3) :: a
      integer :: i
      a=reshape( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ], [ 3, 3])
      print '(3i3)', (a(i,:), i=1,3)
      a = eoshift(a, shift=[ 1, 2, -1], dim=2)
      print *
      print '(3i3)', (a(i,:), i=1,3)
end program test_shift
