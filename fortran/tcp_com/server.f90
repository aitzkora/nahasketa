program server
  use iso_c_binding, only : c_int, c_null_char
  use m_dill, only : ipaddr, ipaddr_local, IPADDR_IPV4

  implicit none
  integer(c_int) :: rc
  type(ipaddr) :: addr

  rc = ipaddr_local(addr, '127.0.0.1' // c_null_char , 5555_c_int, IPADDR_IPV4)

end program server
