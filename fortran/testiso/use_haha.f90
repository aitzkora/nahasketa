module use_f
  public :: ff
  interface
    subroutine ff(x, n)  bind(C, name="f")
      use iso_c_binding, only : c_int, c_ptr
      type(c_ptr), intent(inout) :: x
      integer(c_int), value, intent(in)  :: n
    end subroutine ff

    subroutine free_c(ptr) bind(c, name='free')
      use, intrinsic :: iso_c_binding, only: c_ptr
      type(c_ptr), value, intent(in) :: ptr
    end subroutine free_c

  end interface

end module use_f

program testiso
  use iso_c_binding, only : c_ptr, c_int, c_f_pointer
  use use_f, only : ff, free_c
  implicit none

  integer, parameter :: N = 12
  type(c_ptr) ::x 
  integer(c_int), pointer :: xf(:)

  call ff(x, N)

  call c_f_pointer (x, xf, [N]) 
 
  print *, xf

  call free_c(x)

end program testiso
