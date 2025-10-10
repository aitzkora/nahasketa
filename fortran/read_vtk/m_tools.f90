module m_tools
   use iso_fortran_env
   implicit none
   private
   public :: split

contains 

  function split(str, separator, kwd_len) result(strings)
    character(len=*), intent(in) :: str
    character, intent(in), optional :: separator
    integer, intent(in), optional :: kwd_len
    character(len=:), allocatable :: strings(:)
    integer, allocatable :: positions(:)
    character  :: sep
    integer :: kwd, nb_sep, i, curr
    if (present(separator)) then
      sep = separator 
    else
      sep = ' '
    end if
    if (present(separator)) then 
      kwd = kwd_len
    else
      kwd = 10
    end if
    nb_sep = count_char(str, sep)
    allocate(character(len=kwd)::strings(nb_sep+1))
    allocate(positions(nb_sep+1))
    curr = 0
    positions(1) = 0
    do i=1, len_trim(str)
      if (str(i:i) == sep) then
        curr = curr + 1
        positions(curr+1) = i
      end if
    end do

    do i=1, nb_sep
      strings(i) = str(positions(i)+1:positions(i+1)-1)
    end do
    strings(nb_sep+1) = str(positions(nb_sep+1)+1:len_trim(str))
  end function split

  function count_char(line, char) result(cnt)
    character(len=*), intent(in) :: line
    character, intent(in) :: char
    integer :: cnt, i
    cnt  = 0
    do i=1, len(line)
      if (line(i:i) == char) cnt = cnt+1
    end do
  end function

end module m_tools
