program coucou
     implicit none

     print *, adjust(3)    , adjust2(3)
     print *, adjust(10)   , adjust2(10)
     print *, adjust(100)  , adjust2(100)
     print *, adjust(1000) , adjust2(1000)
     print *, adjust(10000), adjust2(10000)

contains

    function adjust(n) result(nam)
        character(len=30) :: nam
        integer , intent(in ):: n
        write(nam,*) n
        if (n.le.9) then
            nam="000"//trim(adjustl(nam))
        elseif (n.le.99) then
            nam="00"//trim(adjustl(nam))
        elseif (n.le.999) then
            nam="0"//trim(adjustl(nam))
        end if
     end function

     function adjust2(n) result(nam)
        character(len=30) :: nam
        integer , intent(in ):: n
        write(nam,'(i4.4)') n
     end function adjust2

     function adjust3(n) result(nam)
        integer , intent(in ):: n
        character(len=range(n)+2):: nam
        write(nam,'(i0)') n
     end function adjust3


end program coucou
