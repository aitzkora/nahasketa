program zutos
  use iso_fortran_env
  use iso_c_binding
  implicit none
  integer :: i,j
  character(len=:), allocatable :: str(:)
  allocate( character(len=4)::str(4))
  do i=1,4
    do j=1,3
      str(i)(j:j)=char(64+j)
      str(i)(4:4)=endline
    end do
  end do
  print *, str(1:4) 
end program zutos
