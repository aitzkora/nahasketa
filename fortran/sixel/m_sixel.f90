module m_sixel

  use iso_c_binding, only : c_int, c_ptr, c_signed_char
  implicit none


  interface

     function sixel_write(data, selem, desc) bind(c, name="sixel_write")
      use iso_c_binding
        character(c_char), intent(in) :: data(*)
        integer(c_size_t), intent(in), value :: selem
        type(c_ptr) :: desc
        integer(c_int) :: sixel_write
      end function sixel_write

  end interface


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


    function fdopenf(num_desc, mode) bind(C,name="fdopen") result(desc)
    use iso_c_binding
    integer(c_int), intent(in), value  :: num_desc
    character(c_char), intent(in)  :: mode(*)
    type(c_ptr) ::desc
   end function




  end interface
  

  interface

    function sixel_output_new(output, fn_write, priv, allocator) &
        bind(c,name="sixel_output_new")
      use iso_c_binding
      integer(c_int) :: sixel_output_new
      type(c_ptr), intent(inout) :: output
      interface ! callback 
        integer(c_int) function fn_write(data, selem, desc)  bind(C)
          use iso_c_binding
          character(c_char), intent(in) :: data(*)
          integer(c_size_t), intent(in), value :: selem
          type(c_ptr) :: desc
        end function  fn_write
      end interface
      type(c_ptr) :: priv
      type(c_ptr), intent(in), optional :: allocator

    end function sixel_output_new
    

    function sixel_output_create(fn_write, priv) &
        bind(c,name="sixel_output_create")
      use iso_c_binding
      integer(c_int) :: sixel_output_create
      type(c_ptr), intent(in), value :: fn_write
      type(c_ptr), intent(in), value :: priv

     end function sixel_output_create

     subroutine sixel_output_destroy(output) &
        bind(c,name="sixel_output_destroy")
      use iso_c_binding
      type(c_ptr), intent(in), value :: output
     end subroutine sixel_output_destroy

     subroutine sixel_output_ref(output) &
       bind(c,name="sixel_output_ref")
      use iso_c_binding
      type(c_ptr), intent(in), value :: output
     end subroutine sixel_output_ref

     subroutine sixel_output_unref(output) &
       bind(c,name="sixel_output_unref")
      use iso_c_binding
      type(c_ptr), intent(in), value :: output
     end subroutine sixel_output_unref


  end interface

end module m_sixel
