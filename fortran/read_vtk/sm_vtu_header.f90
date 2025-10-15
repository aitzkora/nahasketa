submodule (m_vtu) sm_vtu_header
   use m_tools
   use iso_fortran_env
   use m_vtu
   implicit none
   logical, parameter :: debug = .true.

contains

  module procedure load_paraview_vtu_header
    integer(i4) :: pos
    pos = read_paraview_vtu_header(vtu)
    call read_paraview_vtu_data(vtu, mesh_in, pos)
  end procedure load_paraview_vtu_header

  function read_paraview_vtu_header(vtu) result(header_len)
    type(vtu_file), intent(inout) :: vtu
    integer, parameter :: HEADER_MAX_LINE_NUMBER = 40
    character(len=256) :: lines(HEADER_MAX_LINE_NUMBER)
    integer(i4) :: file_unit, ios, i, header_len
    integer(i4) :: rin(2), rout(2), rsauv(2), offset_int
    integer(i4) ::  nb_components
    character(:), allocatable :: str_name, str_type
     
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
      if ((ios /= 0) .or. (index(trim(lines(i)), '<AppendedData encoding="raw">') /= 0)) exit
    end do
    close(file_unit)
    header_len = i 
    ! check for header
    if (index(lines(1), '<?xml version="1.0"?>') /= 1)  then
       stop -1
    end if  
    ! all format must equal to appended
    do i=2, header_len
      if(index(trim(lines(i)), "format") /= 0) then
        if (get_keyword_str(trim(lines(i)), "format") /= "appended") then
          stop "one format is not 'appended'"
        end if
      end if
    end do
    PIECE : if (extract_keyword_range(lines, "Piece", [2, header_len], rout)) then
      vtu%nb_cells  = get_keyword_int(trim(lines(rout(1))), "NumberOfCells")
      vtu%nb_points = get_keyword_int(trim(lines(rout(1))), "NumberOfPoints")
      if (debug) then
        write(output_unit, '(a,1x,i0)') "number of points : ", vtu%nb_points
        write(output_unit, '(a,1x,i0)') "number of cells  : ", vtu%nb_cells
      end if 
      rin = rout
      if (extract_keyword_range(lines, "Points", rin, rout)) then
          if (debug) write(output_unit, '(a)') repeat("-",7) // " Points " // repeat("-", 7)
          rin = rout
          POINTS_ARRAY: if (extract_keyword_range(lines, "DataArray", rin, rout)) then
            str_type      = get_keyword_str(trim(lines(rout(1))), "type")
            nb_components = get_keyword_int(trim(lines(rout(1))), "NumberOfComponents")
            offset_int    = get_keyword_int(trim(lines(rout(1))), "offset")
            vtu%points = point_header(str_type , nb_components, offset_int)
            if (debug) print '(a,1x, i0,1x,a,1x,i0)', "Components" , nb_components, str_type, offset_int
          end if  POINTS_ARRAY
          if (extract_keyword_range(lines, "Cells", [2, header_len], rout)) then
            if (debug) write(output_unit, '(a)') repeat("-",7) // " Cells " // repeat("-", 7)
            rsauv = rout
            rin = rout
            CELLS : do i=1, header_len ! borne sup
              if (extract_keyword_range(lines, "DataArray", rin, rout)) then
                str_name = get_keyword_str(trim(lines(rout(1))), "Name")
                str_type = get_keyword_str(trim(lines(rout(1))), "type")
                offset_int = get_keyword_int(trim(lines(rout(1))), "offset")
                vtu%cells = [vtu%cells, data_array(str_type, str_name, offset_int)]
                if (debug) print '(a,1x,a,1x,i0)', str_name, str_type, offset_int
                if (rout(2) < rsauv(2)-1) then 
                  rin = [rout(2)+1, rsauv(2)]
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
          if (extract_keyword_range(lines, "PointData", [2, header_len], rout)) then
            if (debug) write(output_unit, '(a)') repeat("-",7) // " PointData " // repeat("-", 7)
            rsauv = rout
            rin = rout
            if (get_keyword_str(trim(lines(rout(1))), "Scalars") == "wavefield") then
              FIELDS : do i=1, header_len ! coarse bound on field number
                if (extract_keyword_range(lines, "DataArray", rin, rout)) then
                  str_name = get_keyword_str(trim(lines(rout(1))), "Name")
                  str_type = get_keyword_str(trim(lines(rout(1))), "type")
                  offset_int = get_keyword_int(trim(lines(rout(1))), "offset")
                  vtu%point_data = [vtu%point_data, data_array(str_type, str_name, offset_int)]
                  if (debug) print '(a,1x,a,1x,i0)', str_name, str_type, offset_int
                  if (rout(2) < rsauv(2)-1) then 
                    rin = [rout(2)+1, rsauv(2)]
                  else
                    exit
                  end if
                else
                  exit
                end if 
              end do FIELDS
            else 
              stop "Scalars not found"
            end if
          else
            stop "PointData not found"
          end if
      else
        stop "Points not Found"
      end if 
    else
      stop "Piece not Found"
    end if PIECE
  end function read_paraview_vtu_header

  subroutine read_paraview_vtu_data(vtu, mesh_out, pos)
    type(vtu_file), intent(in) :: vtu
    type(mesh), intent(inout) :: mesh_out
    integer(i4), intent(in) :: pos
    integer(i4) :: file_unit, i, ios
    integer :: mem_points, mem_cells
    character(len=1) :: c
    open(unit=file_unit, access='stream', action='read', file=vtu%filename, convert='big_endian')
    i = 0 
    ! jump the first pos lines
    do 
      read(file_unit) c
      if (c == new_line(c)) i = i+1
      if (i == pos) exit
    end do
    ! read _ character
    read(file_unit) c 
    ! read memory size for points
    read(file_unit) mem_points
    if (debug) then
      if (mem_points /= 3 * vtu%nb_points*RKIND_MESH) stop "mem points error"
      print '(a,i0)', 'mem points -> ', mem_points
    end if
    ! read points
    allocate(mesh_out%coo(vtu%nb_points,3))
    associate(coo => mesh_out%coo)
      read(file_unit) (coo(i,1),coo(i,2),coo(i,3),i=1,vtu%nb_points)
    end associate
    ! read connection
    read(file_unit) mem_cells
    if (debug) then
      if (mem_cells /= vtu%nb_points*IKIND_MESH) stop "mem cells error"
      print '(a,i0)', 'mem points -> ',  mem_cells
    end if
    allocate(mesh_out%connection(vtu%nb_points))
    read(file_unit,iostat=ios) mesh_out%connection

    close(file_unit)
  end subroutine read_paraview_vtu_data

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
