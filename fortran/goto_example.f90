program zutos
  integer :: i
  print *, hehe(4), " ", hehe(1)
  do i=1, 12
13      print *, "haha"
  end do
contains
    function hehe(x)
      implicit none
      integer, intent(in) :: x
      integer :: hehe
      if (x > 2) go to 12
        hehe = 3
        return
12 hehe = -2
    end function hehe

end program zutos
