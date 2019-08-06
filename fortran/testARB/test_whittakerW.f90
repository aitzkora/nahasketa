program test_whittaker

    use iso_c_binding

    interface
        subroutine compute_u(a, b, z_x, z_y, u_x, u_y) bind(c, name="compute_U")
            use iso_c_binding
            real(c_double), value :: a, b, z_x, z_y
            real(c_double), intent(out) :: u_x, u_y
        end subroutine compute_u

    end interface

    real(c_double) :: a, b, pi = 4.d0*atan(1.d0), res_x_check, res_y_check, prec, res_x, res_y
    complex(c_double) :: res_w, a_c
  
    prec = real(1e-10, c_double)
    ! test compute_u
    res_x_check = 0.416940305395154; ! taken from sage hypergeometric_U(12,20,3.) 
    call compute_u( 12.d0, 20.d0, 3.d0, 0.d0, res_x, res_y )
    call assert_equals( res_x, res_x_check, prec )
    
    ! second case : complex case 
    res_x_check = -0.00646612339420241 
    res_y_check  = 0.0112751987320501;
    call compute_u(12.d0, 20.d0, 3.d0, 2.d0, res_x, res_y); ! taken from hypergeometric_U(12, 20, 3.+2.*I)
    call assert_equals( hypot(res_x - res_x_check, res_y-res_y_check) , 0.d0,  prec);

    ! test whittaker
    a = 1.3d0
    a_c = cmplx( a, 0.d0, c_double)
    res_w = whittaker_w( -.25d0, 0.25d0,  a_c * a_c )
    call assert_equals( erfc(a), exp( -a * a / 2.d0) / sqrt(pi * a) * real( res_w ), prec )

 contains

    complex(c_double) function whittaker_w(k, m, z) result(res)
        real(c_double), intent(in) :: k, m
        complex(c_double), intent(in) :: z
        real(c_double) :: z_re, z_im, u_re, u_im
        z_re = real( z )
        z_im = aimag( z )
        call compute_u(0.5d0 + m - k, 1.d0 + 2.d0* m, z_re, z_im, u_re, u_im)
        res = exp( -z / 2.d0 ) * z ** ( m + 0.5d0 ) * cmplx( u_re, u_im )
    end function whittaker_w


    subroutine  assert_equals(x, y, prec)
        real(c_double), intent(in) :: x, y, prec
        if (abs(x - y) > prec) then
            print *, abs(x - y)
            stop -1
        endif

    end subroutine assert_equals 

end program test_whittaker

