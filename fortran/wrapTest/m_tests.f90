module m_tests
  use iso_c_binding
  use m_asserts
  real(c_double), parameter :: prec=1d-12

contains 

  subroutine test_1()
    call assert_equals_d(return_42(1.d0), 42.d0, prec)
  end subroutine test_1

  subroutine test_another_with_42()
    call assert_equals_d(return_42(5.d0), 42.d0, prec)
  end subroutine test_another_with_42

  subroutine test_false()
    call assert_equals_d(return_42(5.d0), 43.d0, prec)
  end subroutine test_false


   real(c_double) function return_42(x)  result(y)
        real(c_double)  :: x
        y = 42.d0
   end function return_42
     
end module m_tests
