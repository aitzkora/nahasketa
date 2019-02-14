module m_interp

    use iso_fortran_env
    implicit none

    private

    public :: linear

contains

    subroutine  linear(x0, dx, y, z0, dz, z, ierr)
        implicit none
        real(kind=8), intent(in) :: x0, z0, dx, dz
        real(kind=8), intent(in), dimension(:) :: y
        real(kind=8), intent(out), dimension(:) :: z
        integer, intent(out) :: ierr
        integer :: zn, xn, i, ind
        real(kind=8) :: xi, xind
        zn = size(z, 1)
        z = 0
        xn = size(y, 1)
        if ((z0 < x0) .or. ((z0 + (zn-1) * dz) > (x0 + (xn-1) * dx))) then
             write(error_unit,*) "linear is a INTERPOLATING function not EXTRAPOLATING"
             ierr = -1
        end if

        do i = 0, zn-1
               xi = z0 + i * dz
               ind = floor( (xi - x0) / dx )
               xind = x0 + ind * dx
               z(i+1) = (y(ind+1) - y(ind)) / dx * (xi - xind) + y(ind)
               print '(ai0aF9.5)', "z(",i,") = ", z(i+1)
        end do
    end subroutine linear
end module m_interp

program test_interp
    use m_io_matrix
    use m_interp
    use iso_fortran_env
    implicit none
    real(kind=8), allocatable :: input(:, :), output(:,:), z(:)
    real(kind=8) :: error
    integer :: ierr

    call read_matrix("input_check", input )
    call read_matrix("output_check", output, .true.)

    print '(5(3(1xF7.5)/))', transpose(output)

    allocate( z(size( output, 1 )) )

    call linear( input(1,1), input(2,1) - input(1,1), input(:, 2), &
                 output(1,1), output(2,1) - output(1,1), z(:), ierr )

    error = sum( abs( z - output(:, 2) ) )
    if ( error  > 1e-4) then
         write(error_unit,*) "error  = ", error
    end if

end program test_interp
