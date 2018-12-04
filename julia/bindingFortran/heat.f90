module heat
    public :: kernel
contains
    ! FIXME : test is pure is necessarry or not
    pure subroutine kernel(hx, hy, dt, size_x, size_y, u_in,  u_out, error) bind( C, name="heatKernel" )

        use iso_c_binding, only: c_int32_t, c_double
        implicit none
        real(c_double), intent(in) :: hx, hy, dt
        integer(c_int32_t), intent(in) :: size_x, size_y
        real(c_double), dimension( 1:size_x, 1:size_y ), intent(in) :: u_in
        real(c_double), dimension( 1:size_x, 1:size_y ), intent(out) :: u_out
        real(c_double), intent(out) :: error

        integer(c_int32_t) :: i, j
        real(c_double) :: w_x, w_y, d

        w_x =  dt / (hx * hx)
        w_y =  dt / (hy * hy)
        d = 1.d0 - 2.d0 * w_x - 2.d0 * w_y

        error = 0.d0
        do j = 2, size_y - 1
        do i = 2, size_x - 1
        u_out(i,j) = u_in(i,j) * d +  (u_in(i - 1, j) + u_in(i + 1, j)) * w_x + (u_in(i, j - 1) + u_in(i, j + 1)) * w_y
        error = error + (u_out(i,j) - u_in(i, j))**2
        end do
        end do

    end subroutine kernel
end module heat
