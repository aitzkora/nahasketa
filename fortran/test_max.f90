program test_max
  implicit none
  
  type :: element
    integer :: val
  end type
   
  type ::array_of_element
    type(element) :: arr(3)
  end type

  integer  :: i

  type(array_of_element) :: z
  z%arr(:)%val = 8
  print *, maxval(z%arr(:)%val)

end program test_max
