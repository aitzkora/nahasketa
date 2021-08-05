module m_interval
  type inter
  integer a
  integer b
  end type
  interface operator(+)
     module procedure add_inter
  end interface
contains
  function add_inter(i1, i2) result(i3)
    type(inter), intent(in) :: i1, i2
    type(inter) :: i3
    i3 % a = i2 % a + i1 % a
    i3 % b = i2 % b + i1 % b
  end function

end module
program test_inter
 use m_interval

 type(inter) :: i1, i2

 i1 = inter(2, 3)
 i2 = inter(3, 3)

 i2 = i2  + i1 

 print *, 'i2 = ', i2

end program 
