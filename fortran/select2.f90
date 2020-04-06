program zutos
  implicit none
  print *, str2log("true")
  print *, str2log("T")
  print *, str2log("false")
  print *, str2log("1")
  print *, str2log("8")

contains
   function str2log(s) result(b)
       character(len=*) ::s
       logical:: b
       select case(s)
          case ("1","true","T","True")
               b = .true.
          case ("0","false","F","False")
              b = .false.
          case default
               write(*,*) "error" 
               stop 1
       end select
    end function str2log
end program zutos
