module matrix_routines
      implicit none

      private
      public :: eye

  contains

      pure subroutine eye(n,um) bind(C,name="eye") 
          use, intrinsic :: iso_c_binding, only: c_int, c_double
          implicit none
          integer(c_int), intent(in) :: n
          real(c_double), intent(inout), dimension(n,n) :: um
          integer :: i, j

          do j=1,n
             do i=1,n
                um(i,j) =1. / (i+j-1.)
             end do
          end do

          end subroutine eye
end module matrix_routines
