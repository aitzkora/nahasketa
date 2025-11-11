module m_sixel

  use iso_c_binding, only : c_int, c_ptr, c_signed_char, c_int8_t, c_funptr
  implicit none

  integer(c_int) , parameter :: SIXEL_PIXELFORMAT_G8 = 67
  integer(c_int), parameter :: SIXEL_BUILTIN_G8    = 9


  !> interface to ad-hoc functions
  interface

     !> code in  sixel_funcs.c
     function get_win_height() bind(c, name="get_win_height")
        use iso_c_binding
        integer(c_int) :: get_win_height
      end function get_win_height

      !> code in  sixel_funcs.c
     function sixel_write(data, selem, desc) bind(c, name="sixel_write")
      use iso_c_binding
        type(c_ptr), intent(in), value :: data
        integer(c_size_t), intent(in), value :: selem
        type(c_ptr) :: desc
        integer(c_int) :: sixel_write
      end function sixel_write

    !> to handle stdout in Fortran
    function fdopenf(num_desc, mode) bind(C,name="fdopen") result(desc)
      use iso_c_binding
      integer(c_int), intent(in), value  :: num_desc
      character(c_char), intent(in)  :: mode(*)
      type(c_ptr) ::desc
    end function

     !  OK until highest bit gets set.
     function fort_sleep (seconds)  bind ( C, name="sleep" )
       use iso_c_binding
       integer (c_int) :: fort_sleep
       integer (c_int), intent (in), value :: seconds
     end function fort_sleep

  end interface


  !> interface to allocators
  interface

    function sixel_allocator_new(ppallocator, fnmalloc, fn_calloc, fn_realloc, fn_free) &
        bind(c,name="sixel_allocator_new")
      use iso_c_binding
      integer(c_int) :: sixel_allocator_new
      type(c_ptr), intent(inout) :: ppallocator
      type(c_ptr), intent(in), value :: fnmalloc
      type(c_ptr), intent(in), value :: fn_calloc
      type(c_ptr), intent(in), value :: fn_realloc
      type(c_ptr), intent(in), value :: fn_free

    end function sixel_allocator_new

    subroutine sixel_allocator_ref(allocator) &
        bind(c,name="sixel_allocator_ref")
      use iso_c_binding
      type(c_ptr), intent(in), value :: allocator
    end subroutine sixel_allocator_ref
    
    subroutine sixel_allocator_unref(allocator) &
        bind(c,name="sixel_allocator_unref")
      use iso_c_binding
      type(c_ptr), intent(in), value :: allocator
    end subroutine sixel_allocator_unref

    
    function sixel_allocator_malloc(allocator, n) &
        bind(c,name="sixel_allocator_malloc")
      use iso_c_binding
      type(c_ptr) :: sixel_allocator_malloc
      type(c_ptr), intent(in), value :: allocator
      integer(c_size_t), intent(in), value :: n
    end function sixel_allocator_malloc

    function sixel_allocator_calloc(allocator, nelm, elsize) &
        bind(c,name="sixel_allocator_calloc")
      use iso_c_binding
      type(c_ptr) :: sixel_allocator_calloc
      type(c_ptr), intent(in), value :: allocator
      integer(c_size_t), intent(in), value :: nelm, elsize
    end function sixel_allocator_calloc

    function sixel_allocator_realloc(allocator, nelm, elsize) &
        bind(c,name="sixel_allocator_realloc")
      use iso_c_binding
      type(c_ptr) :: sixel_allocator_realloc
      type(c_ptr), intent(in), value :: allocator
      integer(c_size_t), intent(in), value :: nelm, elsize
    end function sixel_allocator_realloc

    subroutine sixel_allocator_free(ppallocator, p) &
        bind(c,name="sixel_allocator_free")
      use iso_c_binding
      type(c_ptr), intent(in), value :: ppallocator
      type(c_ptr), intent(in), value :: p

    end subroutine sixel_allocator_free


  end interface
 
  type, bind(c) :: sixel_output
    integer(c_int) :: ref
    type(c_ptr) :: allocator_ptr
    integer(c_int8_t) ::  has_8bit_control
    integer(c_int8_t) ::  has_sixel_scrolling
    integer(c_int8_t) ::  has_gri_arg_limit
    integer(c_int8_t) ::  has_sdm_glitch
    integer(c_int8_t) ::  skip_dcs_envelope
    integer(c_int8_t) ::  palette_type

    type(c_funptr) :: fn_write

    integer(c_int) :: save_pixel
    integer(c_int) :: save_count
    integer(c_int) :: active_palette

    type(c_ptr) :: node_top
    type(c_ptr) :: node_free

    integer(c_int) :: penetrate_multiplexer
    integer(c_int) :: encode_policy

    type(c_ptr) ::  priv_ptr
    integer(c_int) :: pos
    integer(c_int8_t) ::  buffer(1)

  end type sixel_output

  interface

    integer(c_int) function sixel_output_new(output, fn_write, priv, allocator) &
        bind(c,name="sixel_output_new")
      use iso_c_binding
      type(c_ptr), intent(inout) :: output
      interface ! callback 
        integer(c_int) function fn_write(data, selem, desc)  bind(C)
          use iso_c_binding
          type(c_ptr), intent(in), value :: data
          integer(c_size_t), intent(in), value :: selem
          type(c_ptr) :: desc
        end function  fn_write
      end interface
      type(c_ptr), intent(in), value :: priv
      type(c_ptr), intent(in), optional :: allocator

    end function sixel_output_new
    
     subroutine sixel_output_unref(output) &
       bind(c,name="sixel_output_unref")
      use iso_c_binding
      type(c_ptr), intent(in), value :: output
     end subroutine sixel_output_unref


  end interface


  !> fortran interface to the sixel_dither C struct (only for debug reasons)
  !> you could convert a c_ptr to fortran ptr using the following code
  !> type(c_ptr) :: dither_c
  !> type(sixel_dither) :: dither_f
  !> call c_f_pointer(dither_c, dither_f)
  !> now  dither_f % palette points to the dither_c.palette !

  type, bind(c) :: sixel_dither 
    integer(c_int) ::  ref               
    type(c_ptr) :: palette         
    type(c_ptr) :: cachetable     
    integer(c_int) :: reqcolors
    integer(c_int) :: ncolors
    integer(c_int) :: origcolors
    integer(c_int) :: optimized
    integer(c_int) :: optimize_palette
    integer(c_int) :: complexion
    integer(c_int) :: bodyonly
    integer(c_int) :: method_for_largest
    integer(c_int) :: method_for_rep
    integer(c_int) :: method_for_diffuse
    integer(c_int) :: quality_mode
    integer(c_int) :: keycolor
    integer(c_int) :: pixelformat
    type(c_ptr)  :: allocator
   end type


  !> interfaces to dither functions
  interface

       !> returns a built-in dither context object
       function sixel_dither_get(dither_mode) &
                bind(c, name="sixel_dither_get")
        use iso_c_binding 
        import sixel_dither
        type(c_ptr) :: sixel_dither_get 
        integer(c_int), value :: dither_mode
      end function sixel_dither_get

      !> set the pixel format 
      subroutine sixel_dither_set_pixelformat(dither, pixel_format) &
                 bind(c, name="sixel_dither_set_pixelformat")
        use iso_c_binding
        type(c_ptr), intent(in), value :: dither
        integer(c_int), intent(in), value :: pixel_format
      end subroutine sixel_dither_set_pixelformat

     subroutine sixel_dither_unref(dither) &
       bind(c,name="sixel_dither_unref")
      use iso_c_binding
      type(c_ptr), intent(in), value :: dither
     end subroutine sixel_dither_unref


  end interface
  
  !> interface to encode

   interface

      !> encode in sixel format (dither) the buffer char \c pixels in the current terminal
      integer(c_int) function sixel_encode(pixels, width, height, depth, dither, context) & 
                     bind(c, name="sixel_encode")
        use iso_c_binding 
        type(c_ptr), intent(in), value :: pixels
        integer(c_int), value :: width
        integer(c_int), value :: height
        integer(c_int), value :: depth
        type(c_ptr), intent(in), value :: dither
        type(c_ptr), intent(in), value :: context
      end function sixel_encode

  end interface
   

end module m_sixel
