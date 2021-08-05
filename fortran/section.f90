program s
  integer, allocatable :: a(:,:) 
  a = reshape([1,2,3,4,5,6], [2,3])
  print *, a_sum(a(1,:))
  print *, a_sum(a(:, 2))
contains

    pure function a_sum(s)
      integer, intent(in) :: s(:)
      a_sum = 1 + sum(s)
    end function
end program       
