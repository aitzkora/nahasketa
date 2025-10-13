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
    integer(4) :: file_unit, ios, i, header_len
    integer(4) :: rin(2), rout(2), rsauv(2)
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
    ! FIXME:  must  check that all format are appended
    do i=2, header_len
      if(index(trim(lines(i)), "format") /= 0) then
        if (get_keyword_str(trim(lines(i)), "format") /= "appended") then
          stop "one format is not 'appended'"
        end  if
      end if
    end do
    rin(2) = header_len
    rin(1) = 2
    PIECE : if (extract_keyword_range(lines, "Piece", rin, rout)) then
      NumberOfCells = get_keyword_int(trim(lines(rout(1))), "NumberOfCells")
      NumberOfPoints = get_keyword_int(trim(lines(rout(1))), "NumberOfPoints")
      if (debug) then
        write(output_unit, '(a,1x,i0)') "number of points : ", NumberOfPoints
        write(output_unit, '(a,1x,i0)') "number of cells  : ", NumberOfCells
      end if 
      rin = rout
      if (extract_keyword_range(lines, "Points", rin, rout)) then
          if (debug) write(output_unit, '(a)') repeat("-",7) // " Points " // repeat("-", 7)
          rin = rout
          POINTS_ARRAY: if (extract_keyword_range(lines, "DataArray", rin, rout)) then
            vtu%points%number_of_components = get_keyword_int(trim(lines(rout(1))), "NumberOfComponents")
            vtu%points%offset               = get_keyword_int(trim(lines(rout(1))), "offset")
            vtu%points%type                 = get_keyword_str(trim(lines(rout(1))), "type")
            if (debug) then
              print *, "components : ", vtu%points%number_of_components
              print *, "offset     : ", vtu%points%offset
              print *, "type       : ", vtu%points%type
            end if
          end if  POINTS_ARRAY
          if (extract_keyword_range(lines, "Cells", [2, header_len], rout)) then
            if (debug) write(output_unit, '(a)') repeat("-",7) // " Cells " // repeat("-", 7)
            rsauv = rout
            rin = rout
            CELLS : do i=1, header_len ! borne sup
              if (extract_keyword_range(lines, "DataArray", rin, rout)) then
                block   
                  character(:), allocatable :: str_name, str_type
                  integer(i4) :: offset_int
                  str_name = get_keyword_str(trim(lines(rout(1))), "Name")
                  str_type = get_keyword_str(trim(lines(rout(1))), "type")
                  offset_int = get_keyword_int(trim(lines(rout(1))), "offset")
                  vtu%cells = [vtu%cells, cell_array(str_type, str_name, offset_int)]
                  if (debug) then
                    print *, "type   :", vtu%cells(size(vtu%cells))%type
                    print *, "Name   :", vtu%cells(size(vtu%cells))%name
                    print *, "offset :", vtu%cells(size(vtu%cells))%offset 
                  end if 
                end block 
                if (rout(2) < rsauv(2)-1) then 
                  rin(1) = rout(2)+2
                  rin(2) = rsauv(2)
                else
                  exit
                end if
              else
               exit
              end if 
            end do CELLS
          else
            stop "Cells not Found"
          end if
      else
        stop "Points not Found"
      end if 
    else
      stop "Piece not Found"
    end if PIECE
    
  end subroutine read_paraview_vtu_header_ascii_part


  !> this routine extract from lines(rs_in, re_in) the lines
  !> starting by <keyword> and finishing by </keyword
  !> as a new subrange (rs_out, re_out)
  !> if no keyword is find, the result does not change
  function extract_keyword_range(lines, keyword, rin, rout) result(found)
   character(len=*), intent(in) :: lines(:)
   character(len=*), intent(in) :: keyword
   integer(4), intent(in) :: rin(2)
   integer(4), intent(out) :: rout(2)
   logical :: found
   integer :: i

   rout = rin
   ! search for range start
   do i=rin(1), rin(2)
     if (index(trim(lines(i)), "<"// keyword ) /= 0) exit
   end do
   if (i /= rin(2)) then
     rout(1) = i
     !> search for range end
     do i=rout(1), rin(2)
       if (index(trim(lines(i)), "</"// keyword//">" ) /= 0) exit
     end do
     if (i /= rin(2)) rout(2) = i
   end if
   found = (rout(2) /= rin(2))
  end function extract_keyword_range

  !> kwd must be a constant string
  function get_keyword_str(str_in, kwd) result(str_out)
    character(len=*), intent(in) :: str_in
    character(len=*), intent(in) :: kwd
    integer(4) :: pos, pose, eqidx
    character(:), allocatable :: str, str_out
    logical :: found = .false.
    str = trim(str_in)
    do 
      pos = index(str, kwd)
      if (pos /= 0) then
        eqidx = pos+len(kwd)
        if (str(eqidx:eqidx) == '=') then
          if (str(eqidx+1:eqidx+1) ==  '"') then
            pose = index(str(eqidx+2:), '"')
            if (pose /= 0) then
             str_out = str(eqidx+2:eqidx+pose)
             found = .true. 
             exit
            end if
          end if
        end if
      else
        stop "keyword not found"
      end if
      str = str(2:)
    end do
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
