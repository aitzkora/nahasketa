program t
implicit none
character(1) :: ch
integer :: iu, m, file_address

open ( newunit=iu, file='test.txt', access='stream' )   !, form='formatted' )

call report_address ( iu, file_address )
do
  
!  read (unit=iu, *, end=333, advance='NO') m
  call get_next_number_from_stream ( iu, m )
  print *, 'number recovered =',m
  call report_address ( iu, file_address )
end do

333 continue
end program t

subroutine report_address ( lu, file_address )
  implicit none
  integer :: lu, file_address
  inquire (unit=lu, pos=file_address)
  write (*,*) 'file at byte',file_address
end subroutine report_address

subroutine get_next_number_from_stream ( lu, number )
  implicit none
  integer :: lu, number
  integer :: nc, ic
  integer :: pos = 0
  integer :: czero = ichar('0')
  character :: ch*1, token*10

  nc = 0
  token = ' '
  number = 0
  do
    read (unit=lu, end=333) ch    !  fmt='(a)', 
    pos = pos+1

    ic = ichar (ch)
    if ( ic == 13 ) then
      write (*,*) pos,' <next>', ' <cr>', ic
    else if ( ic == 10 ) then
      write (*,*) pos,' <next>', ' <lf>', ic
    else if ( ic == 9 ) then
      write (*,*) pos,' <next>', ' <ht>', ic
    else if ( ic == 32 ) then
      write (*,*) pos,' <next>', ' <sp>', ic
    else
      write (*,*) pos,' <next>    ', ch, ic
    end if

    if ( index ( '0123456789+-', ch ) > 0 ) then
      nc = nc+1
      token(nc:nc) = ch
      number = number*10 + (ic-czero)     ! simple recovery of positive integer only

    else if ( nc > 0 ) then   ! any non digit character is treated as the end of the numeric token
      exit
    end if

  end do

! retrieve number with list directed I/O works now
!  read ( token, * ) number
  write (*,*) 'next number =',number
  return

333 write (*,*) 'end of file reached, token = '  ,token
    stop
end subroutine get_next_number_from_stream
