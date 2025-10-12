submodule (m_vtu) sm_vtu_header
   use m_tools
   use iso_fortran_env
   use m_vtu
   implicit none
   logical, parameter :: debug = .true.

contains

  module procedure load_paraview_vtu_header
    call  read_paraview_vtu_header_ascii_part(vtu)
  end procedure load_paraview_vtu_header

  subroutine read_paraview_vtu_header_ascii_part(vtu)
    type(vtu_file), intent(inout) :: vtu
    integer, parameter :: HEADER_MAX_LINE_NUMBER = 40
    character(len=256) :: lines(HEADER_MAX_LINE_NUMBER)
    character(len=32), allocatable :: str_split(:)
    integer(4) :: file_unit, ios, i, j, header_len
    integer(4) :: rs1, rs2, re1, re2
    integer(4) :: NumberOfPoints, NumberOfCells
   
    ! open file
    file_unit = 22
    open(unit=file_unit, file= vtu%filename, iostat=ios)
    if ( ios /= 0 )  then
      stop "cannot open "// trim(vtu%filename)
    end if
    ! read all lines of the header and stores them
    do i=1, HEADER_MAX_LINE_NUMBER
      read(file_unit, '(A)', iostat=ios) lines(i)
      lines(i)=adjustl(lines(i))
      if ((ios /= 0) .or. (index(trim(lines(i)), "</UnstructuredGrid>") /= 0)) then
        exit
      end if
    end do
    close( file_unit )
    ! 
    header_len = i 
    ! check for header
    if (index(lines(1), '<?xml version="1.0"?>') /= 1)  then
       stop -1
    end if  
    re1 = header_len
    rs1 = 2
   
    call extract_keyword_range(lines, "Piece", rs1, re1, rs2, re2)
    PIECE : if (re2 /= re1 .and. rs2 /=rs1) then
      NumberOfCells = get_keyword_int(trim(lines(rs2)), "NumberOfCells")
      NumberOfPoints = get_keyword_int(trim(lines(rs2)), "NumberOfPoints")
      if (debug) then
        print * , "number of points ->", NumberOfPoints
        print * , "number of cells ->", NumberOfCells
      end if 
      allocate(vtu%points(NumberOfPoints))
      allocate(vtu%connectivity(NumberOfCells))
      
    else
      stop "Piece not Found"
    end if PIECE
    
  end subroutine read_paraview_vtu_header_ascii_part


  !> this routine extract from lines(rs_in, re_in) the lines
  !> starting by <keyword> and finishing by </keyword
  !> as a new subrange (rs_out, re_out)
  !> if no keyword is find, the result does not change
  pure subroutine extract_keyword_range(lines, keyword, rs_in, re_in, rs_out, re_out)
   character(len=*), intent(in) :: lines(:)
   character(len=*), intent(in) :: keyword
   integer(4), intent(in) :: rs_in, re_in
   integer(4), intent(out) :: rs_out, re_out
   integer :: i

   rs_out = rs_in
   re_out = re_in
   ! search for range start
   do i=rs_in, re_in
     if (index(trim(lines(i)), "<"// keyword ) /= 0) exit
   end do
   if (i /= re_in) then
     rs_out = i
     !> search for range end
     do i=rs_out, re_in
       if (index(trim(lines(i)), "</"// keyword//">" ) /= 0) exit
     end do
     if (i /= re_in) re_out = i
   end if
  end subroutine extract_keyword_range

  !> kwd must be a constant string
  function get_keyword_str(str_in, kwd) result(str_out)
    character(len=*), intent(in) :: str_in
    character(len=*), intent(in) :: kwd
    integer(4) :: pos, pose, eqidx
    character(:), allocatable :: str, str_out
    str = trim(str_in)
    pos = index(str, kwd)
    if (pos /= 0) then
      eqidx = pos+len(kwd)
      if (str(eqidx:eqidx) == '=') then
        if (str(eqidx+1:eqidx+1) ==  '"') then
          pose = index(str(eqidx+2:), '"')
          if (pose /= 0) then
           str_out = str(eqidx+2:eqidx+pose)
          else
            stop 'keyword not finishing by "'
          end if
        else
           stop 'keyword not beginning by "'
        end if
      else
        print *,  'before keyword, there is no ='
      end if
   else
     stop "keyword not found"
   end if
 end function get_keyword_str

 function get_keyword_int(str_in, kwd) result(val)
    character(*), intent(in) :: str_in
    character(*), intent(in) :: kwd
    integer(4) :: val
    character(:), allocatable :: str_out
    str_out = get_keyword_str(str_in, kwd)
    read(str_out, '(i10)') val
 end function get_keyword_int
   


end submodule sm_vtu_header
