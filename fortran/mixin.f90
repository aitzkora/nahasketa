module un
  type :: object
    integer :: x
  contains
     procedure, pass(this) :: get_number => get_num
  end type object
  contains
     integer function get_num(this) result(res)
      class(object), intent(in) :: this
      res = this%x*this%x
    end function get_num
end module un

module un_mixin
  use un, object_orig => object, get_num_orig => get_num

  type, extends(object_orig) :: object_mix
     real :: y
  contains
     procedure, pass(this) :: get_number => get_num_mix
  end type object_mix
  contains
     integer function get_num_mix(this) result(res)
      class(object_mix), intent(in) :: this
      res = this%x*this%x + int(this%y+this%y)
    end function get_num_mix
end module un_mixin

module m_object
  use un_mixin, obj => object_mix
end module m_object
   
program test
   use m_object
   type(obj) :: a
   a = obj(2, 4)
   print * , a%get_number()
end program test

