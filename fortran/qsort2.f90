module sort
  use iso_c_binding

  implicit none

  interface
    subroutine qsort(array,elem_count,elem_size,compare) bind(C,name="qsort")
      import
      type(c_ptr),value       :: array
      integer(c_size_t),value :: elem_count
      integer(c_size_t),value :: elem_size
      type(c_funptr),value    :: compare !int(*compare)(const void *, const void *)
    end subroutine qsort !standard C library qsort
  end interface
contains 

   integer(c_int) function compare( a, b ) bind(C)
     use iso_c_binding
     integer(c_int), intent(in) :: a, b
     compare = a - b
   end function compare
end module sort


program tri_by_qsort

use sort

integer(c_int), allocatable,  target :: a(:)

a = [5,1,9,0,8,7,3,4,6,2]

call qsort( c_loc(a), int(size(a,1), c_size_t), c_sizeof(a(1)), c_funloc(compare) )

print *, a

end program tri_by_qsort


