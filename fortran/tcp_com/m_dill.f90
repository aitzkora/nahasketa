module m_dill
  use iso_c_binding, only : c_char, c_int
  implicit none

  private
  public :: ipaddr, ipaddr_local, IPADDR_IPV4, ipaddr_str, ipaddr_port, from_c

  type, bind(c) :: ipaddr
    character(c_char) :: address(32)
  end type ipaddr

  integer(c_int), parameter :: IPADDR_IPV4 = 1


  interface
    function ipaddr_local(addr, name, port, mode) bind(c, name = "dill_ipaddr_local")
      import :: c_char, c_int, ipaddr
      type(ipaddr), intent(out) :: addr
      character(c_char), intent(in) :: name(*)
      integer(c_int), value, intent(in) :: port
      integer(c_int), value, intent(in) :: mode
    end function ipaddr_local


    subroutine ipaddr_str(addr, ipstr) bind(c, name = "dill_ipaddr_str")
      import :: c_char, c_int, ipaddr
      type(ipaddr), intent(in) :: addr
      character(c_char), intent(out) :: ipstr(*)
    end subroutine ipaddr_str

    function ipaddr_port(addr) bind(c, name = "dill_ipaddr_port")
      import :: c_char, c_int, ipaddr
      type(ipaddr), intent(out) :: addr
      integer(c_int) :: ipaddr_port
    end function ipaddr_port

    module function from_c(string)
        character(len=*) :: string
        character(len=len(string)) :: from_c
    end function from_c 


  end interface

end module m_dill
