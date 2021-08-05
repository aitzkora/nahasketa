module m_utils
  use iso_c_binding, only : c_double, c_char, c_size_t
  implicit none
  private
  public :: clock, host, MAX_HOSTNAME_LEN
  
  integer(c_size_t), parameter :: MAX_HOSTNAME_LEN = 128_c_size_t
  interface

    !function clock() bind(c, name ="clockget")
    !  import :: c_double
    !  real(c_double) :: clock
    !end function clock


    subroutine get_host_name(str, str_len) bind(c, name = "gethostname")
      import :: c_char, c_size_t
      character(c_char), intent(out) :: str(*)
      integer(c_size_t), value, intent(in) :: str_len
    end subroutine get_host_name
  end interface

contains

    function host() 
      character(len=MAX_HOSTNAME_LEN, kind=c_char) :: host
      call get_host_name(host, MAX_HOSTNAME_LEN)
      host = from_c(host)
    end function host
    
    function clock()
      use iso_fortran_env
      real(c_double) :: clock
      integer(int64) :: count_rate, count
      call system_clock(count, count_rate)
      clock = real(count, c_double ) / real(count_rate , c_double)
    end function clock

 
    function from_c(string)
      character(len=*,kind=c_char) :: string
      character(len=len(string), kind=c_char) :: from_c

      integer :: pos
      pos = index( string, achar(0) )
      if ( pos > 0 ) then
        from_c = string(1:pos)
      else 
        from_c = string
      endif
    end function from_c

end module m_utils
