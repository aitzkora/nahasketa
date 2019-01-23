module par_sum2
    use mpi
    use iso_c_binding, only: c_int32_t, c_double
    public:: calc_sum
    private:: compute_slice
contains

    ! the calling subroutine
    subroutine calc_sum(n, x, res) bind(C, name="calc_sum")
        implicit none
        integer(c_int32_t), intent(in) :: n  ! size of the array
        integer(c_int32_t), intent(in) :: x(n) ! main array
        integer(c_int32_t), intent(out) :: res

        integer(c_int32_t) :: sum_loc
        integer(c_int32_t) :: slice(2)
        integer(c_int32_t) :: code, nb_procs, rank
        res = 0
        call MPI_COMM_SIZE( MPI_COMM_WORLD, nb_procs, code)
        call MPI_COMM_RANK( MPI_COMM_WORLD, rank, code)
        ! computing slices
        slice = compute_slice(n, nb_procs, rank)
        sum_loc = sum(x(slice(1):slice(2)))

        call MPI_reduce(sum_loc, res, 1, MPI_INTEGER, MPI_SUM, 0, MPI_COMM_WORLD, code)

    end subroutine calc_sum

    ! private helper function
    pure function compute_slice(n, procs, rank) result(s)
        integer, intent(in) :: n, procs, rank
        integer, dimension(2) :: s
        integer :: length 
        length =  n / procs
        if ( mod(n, procs) == 0 ) then
            s(1) = rank * length + 1
            s(2) = s(1) + length - 1
        else
            if (rank < procs - 1) then
                s(1) = rank * (length + 1) + 1
                s(2) = s(1) + (length + 1) - 1
            else
                s(1) = rank * (length + 1) + 1
                s(2) = s(1) + mod(n, length + 1) - 1
            end if
        end if
    end function compute_slice

end module par_sum2
