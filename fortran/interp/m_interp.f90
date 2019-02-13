module m_interp

  implicit none

  private

  public :: linear

contains

  subroutine  linear(x0, dx, y, z0, dz, z, ierr)
  real(kind=8), intent(in) :: x0, z0, dx, dz
  real(kind=8), intent(in), dimension(:) :: y
  real(kind=8), intent(out), dimension(:) :: z
  integer, intent(out) :: ierr




  end subroutine linear

end module m_interp
program test_interp
   implicit none
   integer :: n_lines, ierr
   real(kind=8), allocatable ::  y(:),  z(:), raw_matrix(:)
   real(kind=8) :: x0, z0, dx, dz
   n_lines = num_lines("input_check")
   allocate( raw_matrix(2*n_lines) , y(n_lines), z(n_lines) )
   open(unit=12, file="input_check")
     read(12,*) raw_matrix
   close(unit=12)
   !print '(52(F9.5xF9.5/))', raw_matrix
   y(:) = raw_matrix(2:2*n_lines:2)
   !print '(52(F9.5/))', y
   x0  = raw_matrix(1)
   dx = raw_matrix(3) - raw_matrix(1)
   z0 = y(1)
   dz = y(2)-y(1)

   call linear(x0, dx, y, z0, dz, z,ierr)

   print *, 
contains 
    function num_lines(filename) result(n)
    character(len=*), intent(in) :: filename
    integer :: n, io_unit
    n = 0
    open(unit = io_unit, file=filename)
    do
    read(io_unit,fmt=*,end=1)
    n = n + 1
    end do
    1 continue
    close(io_unit) 
    end function num_lines
end program test_interp
