module m_asserts
    use iso_c_binding
    implicit none
    public :: assert_equals_c, assert_equals_d
 
contains

    ! assert subroutine to test equality between reals
    subroutine  assert_equals_d(x, y, prec)
        real(c_double), intent(in) :: x, y, prec
        if (abs(x - y) > prec) then
            print *, abs(x - y)
            stop -1
        endif

    end subroutine assert_equals_d

    ! assert subroutine to test equality between complex
    subroutine  assert_equals_c(x, y, prec)
        complex(c_double), intent(in) :: x, y
        real(c_double), intent(in) :: prec
        if (abs(x - y) > prec) then
            print *, abs(x - y)
            stop -1
        endif

    end subroutine assert_equals_c

end module m_asserts
