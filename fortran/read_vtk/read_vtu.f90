program m_vtu_reader
  use iso_fortran_env
  use m_vtu
  implicit none
  integer ::  narg
  character(len=256)::filename
  type(vtu_file) :: vtu 
  type(mesh) :: m
  narg = command_argument_count()
  call get_command_argument( 1, filename)

  call vtu_load(filename, vtu, m)

end program m_vtu_reader
