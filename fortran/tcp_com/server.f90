program server
  use iso_c_binding, only : c_int, c_null_char, c_char
  use m_dill, only : ipaddr, ipaddr_local, IPADDR_IPV4, ipaddr_str, ipaddr_port, from_c

  implicit none
  integer(c_int) :: rc
  type(ipaddr) :: addr
  character(len=128, kind=c_char) :: haha

  rc = ipaddr_local(addr, '127.0.0.1' // c_null_char , 5555_c_int, IPADDR_IPV4)

  call ipaddr_str(addr, haha)
  
  print '(aa)', "name = ", from_c(haha)
  print '(ai0)', "port = ", ipaddr_port( addr ) 


end program server
