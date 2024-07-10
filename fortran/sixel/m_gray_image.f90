module m_gray_image
  use iso_c_binding
  use m_sixel
  implicit none

  !===========================================================================
  !>
  !! \brief type gray_img
  !>
  !===========================================================================

  type :: gray_img
    !> internal sixel output object
    type(c_ptr) :: output 
    !> dither object to encode grayscale
    type(c_ptr) :: dither 
  contains
    !> draw image into buffer
    procedure, pass(self) :: render 
    procedure, pass(self) :: gray_img_constructor
    !final :: gray_img_destroy
  end type gray_img

    

contains
  !===========================================================================
  !>
  !! \brief constructor of gray_img
  !>
  !===========================================================================

   subroutine gray_img_constructor(self)
    class(gray_img), intent(inout) :: self
    integer(c_int) :: status
    status = sixel_output_new(self%output, sixel_write, &
                              fdopenf(fnum(6), "w" // c_null_char))
    if (status /= 0) stop 'cannot create output'
    self%dither = sixel_dither_get(SIXEL_BUILTIN_G8)
    call sixel_dither_set_pixelformat(self%dither, SIXEL_PIXELFORMAT_G8);

  end subroutine gray_img_constructor

  
  function render(self, buff) result(status)
    class(gray_img) :: self
    integer(c_int) :: status
    character(c_char), target, contiguous :: buff(:, :)
    character(32)  :: fmt_size
    integer(c_int) :: m,n
    m = size(buff, 1)
    n = size(buff, 2)
    write (fmt_size, "(a,i0,a,i0,a)") 'Pq"1;1;',m, ';', n, ';'
    write (6, "(a)", advance='no') achar(27) // fmt_size
    status = sixel_encode(c_loc(buff), m, n, 0, self%dither, self%output)
    write (6, "(a)", advance='no') achar(27) // '\'
    write (6, "(a)", advance='no') achar(27) // '8' 
    flush (6)
  end function render

  subroutine gray_img_destroy(img) 
    type(gray_img) :: img
    call sixel_dither_unref(img%dither)
    call sixel_output_unref(img%output)
  end subroutine gray_img_destroy

end module m_gray_image
