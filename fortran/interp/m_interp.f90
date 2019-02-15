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
        xn = size(y, 1)
        if ((z0 < x0) .or. ((z0 + (zn - 1) * dz) > (x0 + (xn - 1) * dx))) then
             write(error_unit,*) "linear is a INTERPOLATING function not EXTRAPOLATING"
             ierr = -1
        end if

        do i = 0, zn - 1
               xi = z0 + i * dz
               ind = floor( (xi - x0) / dx )
               xind = x0 + ind * dx
               z(i+1) = (y(ind+2) - y(ind+1)) / dx * (xi - xind) + y(ind+1)
        end do
    end subroutine linear
end module m_interp

program test_interp
    use m_interp
    use iso_fortran_env
    implicit none
    real(kind=8), allocatable :: z(:), y(:), z_check(:)
    real(kind=8) :: error, dx, dz, dy_max, z_0, x_0
    integer :: ierr, x_n, z_n, i

    x_n = 52
    z_n = 5

    allocate( z( z_n), z_check(z_n),  y(x_n) )
    
    x_0 = real(4.2, selected_real_kind(8)) ! interpolation data sin(x_i) on [4.2,4.71] with h = 1e-3
    dx = real(10e-3, selected_real_kind(8)) !
    y = sin([(x_0 + i * dx, i=0, x_n - 1)]) !
    dy_max = maxval( abs( y(2:x_n) - y(1:x_n -1) ) ) ! max ordonnate error

    dz = real(8e-2, selected_real_kind(8)) ! we interpolate 5 values from z_0 = 4.453 with step 8e-2
    z_0 = real(4.353, selected_real_kind(8))
    z_check = sin([(z_0 + i * dz, i= 0, z_n - 1 )] )

    call linear( x_0, dx, y, z_0, dz, z(:), ierr )

    error = sum( abs( z - z_check ) )
    if ( error  > z_n * dy_max ) then
         write(error_unit, *) achar(27)//'[31m Failed :  '//achar(27)//'[0m' , error, " > " , z_n * dy_max
         stop -1
    else
         write(output_unit,*) achar(27)//'[92m OK '//achar(27)//'[0m', error , " ≤ ", z_n * dy_max
    end if

    deallocate( z, z_check, y)

end program test_interp
