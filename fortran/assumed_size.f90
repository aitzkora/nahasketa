program zutos
   integer :: a(10),b(9)
   a = [(i,i=1,10)]
   b = [(i,i=1,9)]
   print *, titi(a)
   print *, toto(b)

contains 
    pure function titi(x) result(d)
         integer, intent(in) :: x(3,*)
         d= x(1,4) !! valid
    end function titi
    pure function toto(x) result(d)
         integer, intent(in) :: x(3,3)
         d= x(3,3) !! valid
    end function toto
end program zutos
