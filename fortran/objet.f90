module m_mair

 type, abstract :: mair
   integer :: x  
contains
      procedure(action) ,  public,deferred :: do_action

 end type mair

 abstract interface
   integer function action(self) result(res)
      import :: mair
      class(mair), intent(in) :: self
   end function 
 
 end interface

end module m_mair

module m_hilha
     use m_mair
 type, extends(mair) :: hilha
    integer :: y
 contains 
     procedure :: do_action => compute_sum
 end type hilha

contains 
  integer function compute_sum(self) result(res)
  class(hilha), intent(in) :: self

  select type (self)
    class is (hilha)
        res = self % x + self % y
  end select

  end function compute_sum
   
end module m_hilha

module m_hilh
     use m_mair
 type, extends(mair) :: hilh
  integer, allocatable :: vec(:)
 contains 
     procedure :: do_action => trucmuche
 end type hilh

contains 
  integer function trucmuche(self) result(res)
  class(hilh), intent(in) :: self

  select type (self)
    class is (hilh)
        res = self % x + sum(self % vec(:)**2)
  end select

  end function trucmuche
   
end module m_hilh

program example

  use m_mair
  use m_hilha
  use m_hilh

  type(hilha) :: x
  type(hilh), target :: z 
  type(hilh) :: to_check
  class(mair), pointer :: m
  class(mair), allocatable :: m2
  x % x = 12
  x % y = 13
  print *, x % do_action()

  z % x = 12
  z % vec = [1, 2, 3]

  print *, z % do_action()

  m => z 
  print *, m % do_action()
  
  print *, same_type_as(m, to_check)

  allocate( hilh::m2 )

  m2 % x = 3
  !m2 % vec = [integer ::] ! this do not compile
  ! cf Modern Fortran explained p 294

end program example
