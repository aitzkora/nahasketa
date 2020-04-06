program zutos
   implicit none
   character(len=232) :: a
   character(:), allocatable :: b 
   a = "cono"//repeat(" ", 150)
   print *, "a============="//new_line("a")//a//"fin"
   print *, "trim(a)============"//new_line("a")//trim(a)//"fin"
   b = trim(a)
   print *, "b=========="//new_line("a")//b//"fin"
end program
