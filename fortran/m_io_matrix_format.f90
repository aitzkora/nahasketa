module m_io_matrix
  implicit none

  private

  public :: n_rows, n_cols, read_matrix

contains

  function n_rows(filename) result (n)
    character (*), intent (in) :: filename
    integer :: n, io_unit = 12

    n = 0
    open (unit=io_unit, file=filename)
    do
      read (io_unit, fmt=*, end=100)
      n = n + 1
    end do
100 continue
    close (io_unit)
  end function
  function n_cols(filename) result (n)
    character (*), intent (in) :: filename
    ! beware : need to check that max_value
    character (132) :: buffer 

    integer :: n, io_unit = 12, i

    open (unit=io_unit, file=filename)
    read (io_unit, '(a)') buffer
    close (io_unit)
    n = count( [(buffer(i:i),i=1,len(buffer))] ==',') + 1
  end function

  subroutine read_matrix(filename, a, verbose)
    implicit none
    character (*), intent (in) :: filename
    real (kind=8), allocatable, dimension (:, :), intent (inout) :: a
    real (kind=8), allocatable :: raw_data(:)
    logical, optional, intent (in) :: verbose
    logical :: is_verbose
    integer :: m, n, io_unit = 12

    if (.not. (present(verbose))) then
      is_verbose = .false.
    else
      is_verbose = verbose
    end if
    m = n_rows(filename)
    n = n_cols(filename)
    if (is_verbose) then
      print '(ai0ai0a)', 'Found a matrix ', m, ' x ', n, &
        ' in the file ' // trim(filename)
    end if
    allocate (a(m,n), raw_data(m*n))
    open (unit=io_unit, file=filename)
    read (io_unit, *) raw_data
    close (unit=io_unit)
    a = transpose(reshape(raw_data,[n,m]))
  end subroutine

end module
