module shape_mod

type, abstract :: abstractshape
integer :: color
logical :: filled
integer :: x
integer :: y
end type abstractshape

type, EXTENDS (abstractshape) :: shape
end type shape

type, EXTENDS (shape) :: rectangle
integer :: length
integer :: width
end type rectangle

interface rectangle
    module procedure initRectangle
end interface rectangle

contains

! initialize shape  objects
   type(shape) function initShape(color, filled, x, y) result(this)

   integer :: color
   logical :: filled
   integer :: x
   integer :: y
   
   this%color = color
   this%filled = filled
   this%x = x 
   this%y = y

end function  initShape

! initialize rectangle objects
type(rectangle) function initRectangle( color, filled, x, y, length, width) result(this)

integer :: color
logical :: filled
integer :: x
integer :: y
integer, optional :: length  
integer, optional :: width   

   this % shape = initShape(color, filled, x, y)

if (present(length)) then
    this%length = length
else
    this%length = 0
endif

if (present(width)) then 
    this%width = width
else
    this%width = 0
endif
end function initRectangle

end module shape_mod

program test_oop
  use shape_mod 
  implicit none

! declare an instance of rectangle
type(rectangle) :: rect 
! calls initRectangle 
rect = rectangle(2, .false., 100, 200, 11, 22)  

print*, rect%color, rect%filled, rect%x, rect%y, rect%length, rect%width 

end program test_oop
