program higham_trick
    use iso_c_binding
contains
   function compute_diff_trick(f, x, h) result(res)
      real(c_double), intent(in) :: x,h
      external :: f
      real(c_double) :: res
      res = aimag(f(x+dcomplex(0.d0,1.d0)*h))
   end function compute_diff_trick
     


end program higham_trick
