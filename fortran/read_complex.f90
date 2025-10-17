module read_c
  implicit none
  private 
  public :: read_complexes

contains

  function read_complexes(filename) result(tab)
    character(len=*), intent(in) :: filename
    complex(kind=8), allocatable :: tab(:)
    character(len=512) :: line
    integer :: n, io_unit = 12, ios

    n = 0
    ! count total number of complexes
    open(unit = io_unit, file=filename)
    do
      read(io_unit, '(A)', iostat=ios, end=1) line
      n = n + 1
    end do
    1 continue
    close(io_unit)

    allocate(tab(1:n))
    open(unit = io_unit, file=filename)
    read (io_unit, *) tab(1:n)
    close(io_unit)

  end function read_complexes

end module read_c


program rc
  use read_c
  implicit none
  complex(kind=8), allocatable :: zut(:)
  zut = read_complexes("hehe.txt")
  print * , size(zut, 1)
  print *, zut(1:10)
end program rc
