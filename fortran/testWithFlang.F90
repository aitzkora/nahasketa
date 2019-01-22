module testDebile
#include "config.h"
integer, parameter :: sorte = 2 * KIND_MAT
type point
 real(kind=sorte) :: x, y
end type point
type vect
  real(kind=sorte),allocatable :: p(:)
  integer :: length
end type vect

public :: norm, alloc
contains

    pure function norm(p) result (r)
        implicit none
        intrinsic sqrt
        type(point),  intent(in) :: p
        real(kind=sorte) ::  r
        r = sqrt(p%x**2+p%y**2)
    end function

    subroutine alloc(v, n)
     integer, intent(in) :: n
     type(vect), intent(inout) :: v
     allocate(v%p(1:n))
     v%length = n
    end subroutine alloc


end module testDebile

program cono

 use testDebile

  type(point) :: p = point(1.,1.)
  type(vect) :: v
  call alloc(v, 3)
  print *, norm(p)
end program cono


