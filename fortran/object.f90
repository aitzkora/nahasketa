module m_mother

 type, abstract :: mother
   integer :: x  
 contains
   procedure(something), public, deferred :: return_something

 end type mother

 abstract interface
   integer function something(self) result(res)
      import :: mother
      class(mother), intent(in) :: self
   end function 
 
 end interface

end module m_mother

module m_daughter

  use m_mother
  type, extends(mother) :: daughter
    integer :: y
  contains 
    procedure :: return_something => add_x_y
  end type daughter

contains 

  integer function add_x_y(self) result(res)
    class(daughter), intent(in) :: self
    res = self % x + self % y
  end function add_x_y
   
end module m_daughter

module m_son

 use m_mother
 type, extends(mother) :: son
   integer, allocatable :: vec(:)
 contains 
   procedure :: return_something => compute_sum
 end type son

contains 

  integer function compute_sum(self) result(res)
    class(son), intent(in) :: self
    res = self % x + sum(self % vec(:)**2)
  end function compute_sum
   
end module m_son

program example

  use m_mother
  use m_daughter
  use m_son
  type(daughter), target :: x = daughter(12,13)
  type(son), target :: z = son(x=12)
  type(son) :: to_check
  class(mother), pointer :: m

  z % vec = [1, 2, 3] 

  m => x
  print *, m % return_something()

  m => z 
  print *, m % return_something()

  if (same_type_as(m, to_check)) then
      print *, "dynamic type of m => son"
  end if
   
  ! test one : without factory
  block  
    class(mother), allocatable :: m2
    allocate( son::m2 )
    m2 % x = 3
    select type(m2)
    type is (son) ! safeguard type is necessary here, cose static type of m2 is mother
       m2 % vec = [integer ::] ! cf Modern Fortran explained p 294 for a explanation
    end select 
  end block

  ! test two : with factory
  block
    class(mother), allocatable :: m3, m4
    m3 = factory(-2)
    m4 = factory(3)

    print *, "m3 is of type ", type_of(m3)
    print *, "m4 is of type ", type_of(m4)
    print '(*(g0,:,"; "))', m3 % return_something(), m4 % return_something()
  end block
contains 

    function factory(mode) result(instance) 
      integer, intent(in) :: mode
      class(mother), allocatable :: instance

      ! alloc 
      if  (mode < 1) then
         allocate( son::instance )
      else
         allocate( daughter::instance )
      end if
      ! assignement
      select type(instance)
      type is (daughter)
          instance % x = mode
          instance % y = mode
      type is (son)
          allocate (instance % vec(-mode))
          instance % vec(:) = mode
      end select 
    end function

    function type_of(instance) result(str)
      character(len=8) :: str
      class(mother), intent(in), allocatable :: instance
      select type(instance)
      type is (son)
           str = 'son'
      type is (daughter)
          str = 'daughter'
      end select
    end function

end program example
