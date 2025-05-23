program appel
  integer:: x = 2
  integer:: y = 2
  print *, add(x,y)

contains 
  function add (x, y)
    integer, intent(in):: x, y
    integer :: add
    add = x+ y +1
  end function add
end program appel

