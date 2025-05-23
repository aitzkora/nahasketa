program transfert_ex
  use iso_c_binding
  implicit none
  integer(c_int32_t) :: res

  type :: pixel 
    integer(c_int8_t) :: r
    integer(c_int8_t) :: g 
    integer(c_int8_t) :: b 
    integer(c_int8_t) :: alpha
  end type

  type(pixel) :: p1, p2
  
  integer(c_int32_t) :: rx = 33   !! 21
  integer(c_int32_t) :: gx = 28   !! 1C
  integer(c_int32_t) :: bx = 128  !! 80
  integer(c_int32_t) :: ax = 255  !! FF

  res = ieor(ishft(rx, 24), ieor(ishft(gx, 16), ieor(ishft(bx, 8), ax)))
  p2 = transfer(res, p1)
  print "(z0)", res 
  !print "(4(z0,1x))", [p2%r, p2%g, p2%b, p2%alpha]
  print *, ichar(transfer([p2%r, p2%g, p2%b, p2%alpha], 'a', 4))

end program transfert_ex
