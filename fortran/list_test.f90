module tools
 type :: list
  integer :: value
  type(list), pointer :: next
 end type list
contains

 subroutine print_list(l)
   type(list), intent(in), target :: l
   type(list), pointer :: p
   p => l
   do 
     if (.not. associated(p)) exit
     print *, p%value
     p = p%next
   end do
 end subroutine print_list

end module tools


program use_tools
  use tools
  type(list) :: l1
  l1 % value = 2
  l1 % next => null()
  call print_list(l1)
end program use_tools
