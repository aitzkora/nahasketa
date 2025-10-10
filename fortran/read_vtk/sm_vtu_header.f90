submodule (m_vtu) sm_vtu_header
   use m_tools
   use iso_fortran_env
   use m_vtu
   implicit none

contains

  module procedure load_paraview_vtu_header
    call  read_paraview_vtu_header_ascii_part(vtu)
  end procedure load_paraview_vtu_header

  subroutine read_paraview_vtu_header_ascii_part(vtu)
    type(vtu_file), intent(inout) :: vtu
    integer, parameter :: HEADER_MAX_LINE_NUMBER = 40
    character(len=256) :: lines(HEADER_MAX_LINE_NUMBER)
    character(len=:), allocatable :: str_split(:)
    integer  :: file_unit, ios, i, header_len, size_loc, j
   
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
    do i=2, header_len
        size_loc = len_trim(lines(i))
        if (lines(i)(1:1) /= '<' .or. lines(i)(size_loc:size_loc) /= '>') then
           print *, "not a keyword line : ", i, '"', trim(lines(i)), '"'
         else
           str_split = split(lines(i)(2:size_loc-1), ' ', 250)
           do j=1, size(str_split)
             write(output_unit,'(a,1x)', advance='no') "'" // trim(str_split(j)) // "'"
           end do
           write(output_unit,'(/)', advance='no')
         end if
    end do

  end subroutine read_paraview_vtu_header_ascii_part
end submodule sm_vtu_header
