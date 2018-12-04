module heat
    public :: kernel
contains
    ! FIXME : test is pure is necessarry or not
    pure subroutine kernel(size_x, size_y, u_in,  u_out, error) bind( C, name="heatKernel" )

        use iso_c_binding, only: c_int32_t, c_double
        implicit none
        integer(c_int32_t), intent(in) :: size_x, size_y
        real(c_double), dimension( 1:size_x, 1:size_y ), intent(in) :: u_in
        real(c_double), dimension( 1:size_x, 1:size_y ), intent(out) :: u_out
        real(c_double), intent(out) :: error

        integer(c_int32_t) :: i, j

        error = 0.d0
        do j = 2, size_y - 1
           do i = 2, size_x - 1
           u_out(i,j) = 4.d0 * u_in(i, j) - u_in(i - 1, j) - u_in(i + 1, j) - u_in(i, j - 1) - u_in(i, j + 1)
           error = error + (u_out(i,j) - u_in(i, j))**2
           end do
        end do

    end subroutine kernel
end module heat
