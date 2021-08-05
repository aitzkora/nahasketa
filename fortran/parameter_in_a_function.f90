program zutos

    print *, plus_p(3)

contains 
  pure function plus_p(x) result (pp)
     integer, intent(in) ::  x
     integer :: pp
     integer, parameter :: p = 2
     pp = x + p
  end function

end program zutos
