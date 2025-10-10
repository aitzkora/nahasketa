module m_vtu
  
  use, intrinsic :: iso_fortran_env, only: int8, int16, int32, int64
  use, intrinsic :: ieee_arithmetic, only: ieee_selected_real_kind

  integer, parameter :: i1 = int8
  integer, parameter :: i4 = int32
  integer, parameter :: i8 = int64
  integer, parameter :: MAX_NAMES_LENGTH=250
  integer, parameter :: r8 = selected_real_kind(15,307)

  public  :: vtu_load, vtu_file
  
  ! > type for wave field
  type :: wavefield
    real(i8), allocatable :: values(:)
    character(len=MAX_NAMES_LENGTH), allocatable :: name
  end type wavefield

  
  ! file type
  type :: vtu_file
    character(len=:), allocatable :: filename
    real(r8), allocatable :: points(:)
    integer(i4), allocatable :: connectivity(:)
    integer(i1), allocatable :: types(:)
    integer(i4), allocatable :: offsets(:)
    type(wavefield), allocatable :: fields(:)
  end type 


  interface
   module subroutine load_paraview_vtu_header(vtu)
     type(vtu_file), intent(inout) :: vtu
   end subroutine load_paraview_vtu_header   
  end interface

contains

  subroutine vtu_load(filename, vtu)
    character(len=*), intent(in) :: filename
    type(vtu_file), intent(inout) :: vtu
    allocate( character(len=len(filename)) :: vtu%filename)
    vtu%filename = filename
    call load_paraview_vtu_header(vtu)
  end subroutine vtu_load

end module m_vtu
