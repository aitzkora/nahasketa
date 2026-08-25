program factorial_el
   implicit none
   print *, factorial([6,7])
contains
  elemental function factorial(n) result(fact_n)
      integer, intent(in) :: n
      integer :: fact_n, i
      fact_n = product([(i,i=1,n)])
  end function factorial
end program factorial_el
