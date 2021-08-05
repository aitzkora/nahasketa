program zutos

   character(25):: tab(5) =  ["abc  ", " defi", "111  ", " def ", "222  "]
   print *, findloc(tab,"def")
   print *, findloc(index(tab,"def")>0, .true., dim=1)
end program zutos
