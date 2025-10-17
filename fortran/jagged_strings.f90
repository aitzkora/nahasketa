program jagged_strings
  implicit none
  integer :: i
  type jagged
    character(len=:), allocatable :: chars
  end type jagged
  type(jagged), allocatable :: strings(:)
  allocate( strings(2))
  strings(1)%chars = "heh"
  strings(2)%chars = "hoho"
  do i = 1, 2
     print *, strings(i)%chars
  end do
  print *, ["jaja", "jojo"]
end program jagged_strings
