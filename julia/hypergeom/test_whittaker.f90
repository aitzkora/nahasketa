program test_whittaker

    use iso_c_binding

    interface
        function hyperg_u(a, b, x) bind(c, name="gsl_sf_hyperg_U")
            use iso_c_binding
            real(c_double), value :: a, b, x
            real(c_double) :: hyperg_u
        end function hyperg_u

        function hyperg_1f1(a, b, x) bind(c, name="gsl_sf_hyperg_1F1")
            use iso_c_binding
            real(c_double), value :: a, b, x
            real(c_double) :: hyperg_1f1
        end function hyperg_1f1

    end interface

    real(c_double) :: a, b, check, pi = 4.d0*atan(1.d0), dUdx, x = 45.d0, k, m, z
    a= 1.3d0
    b = 100.d0
    check = abs(erfc(a)-exp(-a*a/2.d0)/sqrt(pi*a)*whittakerW(-0.25d0, 0.25d0, a*a))
    print *, check
    dUdx = 1e3*(hyperg_u(a, b, x+1e-3) - hyperg_u(a,b,x))
    print *, abs(dUdx - (-a*hyperg_u(a+1,b+1,x)))

    k = 12.d0
    m = 25.d0
    z = 53.2d0
    print *, abs(whittakerW(k, m, z) - gamma(-2.d0 * m) / gamma(0.5d0 - m - k) * whittakerM(k,  m, z) - &
                                       gamma( 2.d0 * m) / gamma(0.5d0 + m - k) * whittakerM(k, -m, z))

 contains

    real(c_double) function whittakerM(k, m, x) result(r)
        real(c_double), intent(in) :: k, m, x

        r = exp(-x/2.)*x**(m+0.5)*hyperg_1f1(0.5+m-k, 1 + 2.* m, x)
    end function whittakerM

    real(c_double) function whittakerW(k, m, x) result(r)
        real(c_double), intent(in) :: k, m, x

        r = exp(-x/2.)*x**(m+0.5)*hyperg_u(0.5+m-k, 1 + 2.* m, x)
    end function whittakerW

end program test_whittaker

