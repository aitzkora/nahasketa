program object_bound

  type struct
    real(kind=8) :: x(3)
    procedure(one_kind), pointer, pass(obj):: p
  end type struct

  abstract interface
    function  one_kind(offset, obj) result(w)
      import :: struct
      real(kind=8) :: offset, w
      class(struct) :: obj 
    end function
  end interface

! example to illustrate the object bound method concept
  ! in fortan

  type(struct) :: s
  s % x = [1,2,3] *1.d0
  s % p => obj_bnd_fcn
  print *, s % p (1.d0)
  !s % p => obj_bnd_fcn_rev
  print *, s % p (2.d0)


contains

  function obj_bnd_fcn(a,b) result(w)
    real(kind=8) :: a, w
    class(struct) :: b 
    w = a + sum( b % x)
  end function

  function obj_bnd_fcn_rev(a, b) result(w)
    real(kind=8) :: b, w
    class(struct) :: a 
    w = b / sum( a % x)
  end function


  end program
