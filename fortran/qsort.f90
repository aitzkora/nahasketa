module m_sort
  use :: iso_c_binding

  implicit none

  !> Interface to C sorting function ctxqsort.
  interface 
    subroutine qsortf(array,length,isize,compar) bind(C, name="qsort")
      use iso_c_binding
      type(c_ptr),intent(in),value        :: array
      integer(c_size_t),intent(in),value  :: length
      integer(c_size_t),intent(in),value  :: isize

      interface
        integer(c_int) function compar(a,b)  bind(C)
          use iso_c_binding
          type(c_ptr),intent(in),value :: a,b
        end function compar
      end interface
    end subroutine qsortf
  end interface
contains 

  integer(c_int) function cmp(ca,cb)
    use iso_c_binding
    implicit none
    type(c_ptr), intent(in), value :: ca,cb
    integer(c_int), pointer :: a(:), b(:)
    call c_f_pointer(ca, a, [1])
    call c_f_pointer(cb, b, [1])

    cmp = a(1) - b(1) 
  end function cmp

end module m_sort

program use_sort
   use m_sort
   integer, allocatable, target :: a(:)

   a = [3,1, 4, 5, 10, 0]
   
   call qsortf(c_loc(a), int(size(a,1), c_size_t), c_sizeof(a(1)), cmp)
   print *, a
end program use_sort
