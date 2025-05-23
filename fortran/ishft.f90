module compact
  use iso_c_binding
  implicit none

  type :: pixel
    integer(c_int32_t) :: r
    integer(c_int32_t) :: g
    integer(c_int32_t) :: b
   !generic ::  operator(==) => pixel_equal_pixel
  end type 
  
  type :: pixel8
    integer(c_int8_t) :: r
    integer(c_int8_t) :: g
    integer(c_int8_t) :: b
   !generic ::  operator(==) => pixel_equal_pixel
  end type 

  !interface operator(==)
  !  logical pure function pixel_equal_pixel(p,q)
  !     import :: pixel
  !     type(pixel), intent(in) :: p,q
  !  end function 
  !end interface

contains


   !logical pure function pixel_equal_pixel(p1, p2) result(b)
   !   type(pixel),intent(in) :: p1, p2
   !   b = (p1%r == p2%r) .and. &
   !       (p1%g == p2%g) .and. &
   !       (p1%b == p2%b) 
   !end function pixel_equal_pixel
 


   elemental integer(c_int32_t) function batu(p) result(rgb)
     type(pixel), intent(in) :: p
     rgb = ieor(ishft(p%r, 24), ieor(ishft(p%g, 16), ieor(ishft(p%b, 8), 255)))
   end function batu

   elemental type(pixel) function banatu(rgb) result(p)
      integer(c_int32_t), intent(in) :: rgb
      p % r = ishft(rgb, -24)
      p % g = ishft(iand(rgb, z'00FF0000'), -16)
      p % b = ishft(iand(rgb, z'0000FF00'), -8)
   end function banatu

   elemental type(pixel8) function banatu8(rgb) result(p)
      integer(c_int32_t), intent(in) :: rgb
      p % r =transfer(ishft(rgb, -24), 1_c_int8_t)
      p % g =transfer(ishft(iand(rgb, z'00FF0000'), -16), 1_c_int8_t)
      p % b =transfer(ishft(iand(rgb, z'0000FF00'), -8), 1_c_int8_t)
   end function banatu8


end module compact


program test_compact
  use compact
  implicit none
  integer(c_int32_t), allocatable :: a(:)
  type(pixel), allocatable :: b(:), c(:)
  type(pixel8), allocatable :: c8(:)
  
  b = spread(pixel(int(z'AA'),int(z'BB'),int(z'CC')), 1, 2)
  print *, b 
  a = batu(b)
  print *, "apres batu"
  print '(z0)', a 
  c8 = banatu8(a)
  print *, "apres banatu"
  print '(z0)', banatu8(a)
  !if (any(c == b)) then
  !  print *, '*******SUCCESS***********'
  !else
  !  print *, '*******ERROR*************'
  !end if 
  

end program test_compact
