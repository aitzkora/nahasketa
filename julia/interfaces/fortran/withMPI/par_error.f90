module par_error
    use mpi
    use iso_c_binding, only: c_int32_t, c_double
    public:: compute_error
    private:: compute_slice, cumsum
contains

    ! the calling subroutine
    ! compute in a // way : 
    !    - the objective function 0.5 * | x -c |**2
    !    - the gradient x - c  

    subroutine compute_error(n, x, c, f, df) bind(C, name="compute_error")
        implicit none
        integer(c_int32_t), intent(in) :: n  ! size of the array
        real(c_double), intent(in) :: x(n), c(n) !
        real(c_double), intent(out) :: f
        real(c_double), intent(out) :: df(n)

        real(c_double), allocatable :: f_loc, df_loc(:)
        integer(c_int32_t) :: slice(2)
        integer(c_int32_t) :: code, nb_procs, rank, is, ie, loc_size
        integer(c_int32_t), allocatable :: sizes(:), displacements(:)
        
        !call MPI_COMM_SIZE( MPI_COMM_WORLD, nb_procs, code)
        !call MPI_COMM_RANK( MPI_COMM_WORLD, rank, code)
       
        !! computing slices
        !slice = compute_slice(n, nb_procs, rank)
        !is = slice(1)
        !ie = slice(2)
        !print *, is 
        ! computing objective
        !f_loc = 0.5d0 * sum( (x(is:ie) - c(is:ie))**2 )
        !call MPI_REDUCE( f_loc, f, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD, code )
        !print *, f_loc
        ! computing gradient and ...
        !df_loc = x(ie:is) - c(ie:is)
        
        ! communicate it

        !loc_size = is - ie + 1
        !if (rank == 0) then 
        !    allocate( sizes(nb_procs) )
        !end if
        !call MPI_GATHER( sizes, 1, MPI_INT, loc_size, 1, MPI_INT, 0, MPI_COMM_WORLD, code)
        
        !if (rank == 0) then
        !   displacements = [0, cumsum(sizes)]
        !   print * , "disps = ", displacements 
        !endif  
        !call MPI_GATHERV( df_loc , sizes(rank + 1), MPI_DOUBLE, &
        !                  df, sizes, displacements, MPI_DOUBLE, 0, MPI_COMM_WORLD, code)
 
        
    end subroutine compute_error

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

    pure function cumsum(x) result(y)
        implicit none
        integer(c_int32_t), intent(in) :: x(:)
        integer(c_int32_t) :: y(size(x,1))
        integer :: i
        y(1) = 0
        do i =2, size(x, 1)
           y(i) = y(i-1) + x(i-1)
        end do

    end function cumsum


end module par_error
