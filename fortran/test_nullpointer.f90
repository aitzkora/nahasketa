program test_pointer

  integer :: i
  integer, allocatable :: tab1(:), tab2(:)

  tab1 = [(i,i=1,10)]
  tab2 = [integer::]

  call use_array( tab1, tab2, i)
  print *, i

contains

  subroutine use_array(arr1, arr2, res)
      integer, intent(in), dimension(:):: arr1, arr2
      integer, intent(out) :: res
      res = sum(arr1)
      if (size(arr2) /= 0) then
          print *, "le second tableau n'est pas vide"
      else
          print *, "le second tableau est vide"
      end if
    end subroutine use_array


end program test_pointer
