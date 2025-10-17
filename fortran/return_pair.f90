program return_pair
  use iso_fortran_env
  use iso_c_binding
  implicit none
  integer :: c(2)

  c = plage(1)
  print *, c(1)

contains 
    pure function plage(n) result(pair)
       integer, intent(in) :: n
       integer :: pair(2)
       pair(1) = n+1
       pair(2) = n-1
    end function plage 

end program return_pair
