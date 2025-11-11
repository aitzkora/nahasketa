module m_gray_image
  use iso_c_binding
  use iso_fortran_env
#ifdef __intel__
  use ifposix
#endif
  use m_sixel
  implicit none
#ifdef __NVCOMPILER
    include 'lib3f.h' !> for getfd
#endif

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
    !final :: gray_img_destroy
  end type gray_img


contains
  !===========================================================================
  !>
  !! \brief constructor of gray_img
  !>
  !===========================================================================

   subroutine gray_img_create(img)
    type(gray_img), intent(inout) :: img
    integer(c_int) :: status
    integer :: fdesc
#ifdef __GFORTRAN__
    fdesc = fnum(output_unit)
#elif __INTEL_COMPILER
    integer :: ierr
    call pxffileno(output_unit, fdesc, ierr)
    if (ierr /= 0) stop "can not retrieve fdesc"
#elif __NVCOMPILER
    fdesc = getfd(output_unit)
#endif

    status = sixel_output_new(img%output, sixel_write, &
                              fdopenf(fdesc, "w" // char(0)))
    if (status /= 0) stop 'cannot create output'
    img%dither = sixel_dither_get(SIXEL_BUILTIN_G8)
    call sixel_dither_set_pixelformat(img%dither, SIXEL_PIXELFORMAT_G8);

  end subroutine gray_img_create
  !===========================================================================
  !>
  !! \brief draw the bitmap grayscale image stored in the buffer \c buff
  !> \param[in] buff : char 2D array
  !> note : buff must have the target attribute (due to c_loc call!)
  !===========================================================================
  
  function render(self, buff) result(status)
    class(gray_img) :: self
    integer(c_int) :: status
    character(c_char), target, contiguous :: buff(:, :)
    character(32)  :: fmt_size, clr_str
    integer(c_int) :: m, n, win_height, secs
    m = size(buff, 1)
    n = size(buff, 2)
    !!write (fmt_size, "(a,i0,a,i0,a)") 'Pq"1;1;',m, ';', n, ';' 
    !!write (fmt_size, "(a,i0,a,i0,a)") '[1;1;H' 
    win_height = get_win_height() 
    write (clr_str, '(i0)') win_height
    !write (output_unit, "(a)", advance='no') achar(27) // "[1;1;H"
    write (output_unit, "(a)", advance='no') achar(27) // '7'
    status = sixel_encode(c_loc(buff), m, n, 0, self%dither, self%output)
    write (output_unit, "(a)", advance='no')  achar(27) // '8' 
    flush (output_unit)
  end function render
 
  !===========================================================================
  !>
  !! \brief destructor for gray_img type
  !===========================================================================
  
  subroutine gray_img_destroy(img) 
    class(gray_img) :: img
    call sixel_dither_unref(img%dither)
    call sixel_output_unref(img%output)
  end subroutine gray_img_destroy

end module m_gray_image
