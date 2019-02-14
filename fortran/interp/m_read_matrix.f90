module m_io_matrix
    implicit none

    private

    public :: n_rows, n_cols, read_matrix

contains

     function n_rows(filename) result(n)
        character(len=*), intent(in) :: filename
        integer :: n, io_unit = 12
        n = 0
        open(unit = io_unit, file=filename)
        do
            read(io_unit,fmt=*,end=1)
            n = n + 1
        end do
        1 continue
        close(io_unit)
    end function n_rows
     function n_cols(filename) result(n)
        character(len=*), intent(in) :: filename
        character(len=132) ::buffer ! beware : need to check that max_value
        integer :: n, io_unit = 12, i
        open(unit = io_unit, file=filename)
        read(io_unit,'(a)') buffer
        close(io_unit)
        n = count([(buffer(i:i), i=1,len(buffer))] == ',') + 1
    end function n_cols

    subroutine read_matrix(filename, a, verbose)
        implicit none
        character(len=*), intent(in) :: filename
        real(kind=8), allocatable, dimension(:,:), intent(in out) :: a
        logical, optional, intent(in) :: verbose
        logical :: is_verbose
        integer :: m, n, io_unit = 12
        if (.not.( present(verbose) ) ) then 
             is_verbose = .false.
        else
             is_verbose = verbose
        end if
        m = n_rows(filename)
        n = n_cols(filename)
        if (is_verbose) then
           print '(ai0ai0a)', "Found a matrix ", m , " x ", n, " in the file " // trim(filename)
        end if
        allocate( a(m, n) )
        open(unit=io_unit, file=filename)
        read(io_unit,*) a
        close(unit=io_unit)
    end subroutine read_matrix

end module m_io_matrix
