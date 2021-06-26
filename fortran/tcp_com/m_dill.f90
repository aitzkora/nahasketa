module m_dill
  use iso_c_binding, only : c_char, c_int
  implicit none

  private
  public :: ipaddr, ipaddr_local, IPADDR_IPV4

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

  end interface

end module m_dill
