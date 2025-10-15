module m_vtu
  
  use, intrinsic :: iso_fortran_env, only: int8, int16, int32, int64
  use, intrinsic :: ieee_arithmetic, only: ieee_selected_real_kind
  integer, parameter :: RKIND_MESH = 8
  integer, parameter :: IKIND_MESH = 4


  integer, parameter :: i1 = int8
  integer, parameter :: i4 = int32
  integer, parameter :: i8 = int64
  integer, parameter :: MAX_NAMES_LENGTH=250
  integer, parameter :: r8 = selected_real_kind(15,307)

  public  :: vtu_load, vtu_file, mesh
  
  type :: data_array
    character(:), allocatable :: type
    character(:), allocatable :: name
    integer(i4) :: offset
  end type data_array

  type :: point_header
    character(:), allocatable :: type
    integer(i4) :: number_of_components
    integer(i4) :: offset
  end type point_header

  ! file type
  type :: vtu_file
    character(len=:), allocatable :: filename
    integer(i4) :: nb_points
    integer(i4) :: nb_cells
    type(point_header) :: points
    type(data_array), allocatable :: cells(:)
    type(data_array), allocatable :: point_data(:)
  end type 

  type :: mesh
   real (kind=RKIND_MESH)  , allocatable :: coo(:,:)
   integer(kind=IKIND_MESH)  , allocatable :: connection(:)
  end type

  interface
   module subroutine load_paraview_vtu_header(vtu, mesh_in)
     type(vtu_file), intent(inout) :: vtu
     type(mesh), intent(inout) :: mesh_in
   end subroutine load_paraview_vtu_header   
  end interface

contains

  subroutine vtu_load(filename, vtu, mesh_in)
    character(len=*), intent(in) :: filename
    type(vtu_file), intent(inout) :: vtu
    type(mesh), intent(inout) :: mesh_in
    allocate( character(len=len(filename)) :: vtu%filename)
    vtu%filename = filename
    call load_paraview_vtu_header(vtu, mesh_in)
  end subroutine vtu_load

end module m_vtu
