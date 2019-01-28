module heat

    public :: stencil_4

contains

subroutine stencil_4(hx, hy, dt, u_in, u_out, error)
    use iso_c_binding, only: c_int32_t, c_double
    implicit none
    real(c_double):: hx, hy, dt
    real(c_double), dimension(:, :), intent(in) :: u_in
    real(c_double), dimension(:, :), intent(out) :: u_out
    real(c_double), intent(out) :: error
    integer(c_int32_t) :: i, j
    real(c_double) :: w_x, w_y, d

    w_x =  dt / (hx * hx)
    w_y =  dt / (hy * hy)
    d = 1.d0 - 2.d0 * w_x - 2.d0 * w_y
    error = 0.d0
    do j = 2, size( u_in, 2) - 1
        do i=2, size( u_in, 1) - 1
            u_out(i,j) = u_in(i,j) * d + &
                        (u_in(i - 1, j) + u_in(i + 1, j)) * w_x + &
                        (u_in(i, j - 1) + u_in(i, j + 1)) * w_y
            error = error + (u_out(i,j) - u_in(i, j))**2
       end do
    end do

end subroutine stencil_4

end module heat
