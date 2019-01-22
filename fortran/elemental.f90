program test_elemental
   implicit none
   integer :: i
   real(kind=8), allocatable, dimension(:) :: x
   x = [(1.*i,i=-10,10)]

   print *, heavyside(x)


contains
elemental function heavyside(x)
    real(kind=8), intent(in) :: x
    real(kind=8) :: heavyside
    if (x >= 0) then
      heavyside = 1.
    else
      heavyside = 0.
  end if
end function heavyside

end program test_elemental
