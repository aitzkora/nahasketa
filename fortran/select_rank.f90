program zutos
  integer ::  x(2,2)
  print *,rank(x)


contains 
    pure function toto(x) result (r)
    integer, intent(in)::  x(..)
    integer:: r
    select rank(x)
     rank(1) 

end select
end function toto


end program zutos
