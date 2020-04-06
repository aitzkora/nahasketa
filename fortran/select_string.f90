program zutos
  implicit none
  integer :: narg, i
  character(len=82) :: param, param_without_quotes
  narg = command_argument_count()
  if (narg < 1) then
      call get_command_argument( 0, param)
      print *, trim(param) // " string "
      stop
  else
      call get_command_argument( 1, param)
  end if

  select case(remove_quotes(trim(param)))
  case ("fun1")
      call fun1()
  case ("fun2")
      call fun2()
  case default
      print *, trim(param), " does not exist "
  end select
contains
   subroutine fun1()
       print * , "je suis fun1"
   end subroutine fun1

   subroutine fun2()
       print * , "je suis fun2"
   end subroutine fun2

   function remove_quotes(str_in) result( str_out )
       character(len=*), intent(in):: str_in
       character(len=:), allocatable :: str_out
       integer :: i_src, i_dest
       allocate( character(len=len(str_in)) :: str_out)
       i_dest = 1
       do i_src=1, len(str_in)
           if (str_in(i_src:i_src) /= '"') then
               str_out(i_dest:i_dest) = str_in(i_src:i_src)
               i_dest = i_dest + 1
           end if
       end do
   end function remove_quotes
end program zutos
