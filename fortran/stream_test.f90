program st
    character(len=80) ::enreg
    character(len=256) :: msg
    integer :: i, ios
    open (unit=1,file="debilos", access="stream", action="read", & 
        form="formatted")
    i = 0
    do 
      read(unit=1, fmt='(a)', iomsg=msg, iostat=ios, advance="yes") enreg
      if (ios /= 0) exit
      print '(a)', trim(enreg) 
      print *, i
      !print '(a1xi0)', enreg, i
      i = i +1
    end do
end program st
