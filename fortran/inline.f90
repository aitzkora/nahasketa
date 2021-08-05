program inline
    implicit none
    integer :: i
    integer, parameter:: dp =selected_real_kind(8)
    real(kind=dp) :: s = 0.d0
    do i=1, 10000
      s = s + f_to_zutos(1.d0*i) 
    end do
contains 
    pure function f_to_zutos(x) result(f)
     real(kind=dp), intent(in) :: x
     real(kind=dp) :: f

     f = 1.d0 /sin(erfc(x))**(0.33d0)

    end function



end program inline
