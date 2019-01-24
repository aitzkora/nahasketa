program heat_main
    use heat_solve
    use mpi
    use iso_c_binding, only: c_int32_t, c_double
    implicit none
    integer(c_int32_t) :: n_x, n_y, p_x, p_y, iter_max, ierr
    integer :: rank_w, size_w, narg
    logical :: verbose
    integer :: snapshot_size, snapshot_step
    real(kind=c_double), allocatable :: solution(:,:,:)
    character(len=10)::param


    call MPI_INIT(ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, rank_w, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, size_w, ierr)

    verbose = (rank_w == 0)

    narg = command_argument_count()
    if (narg < 5) then
        call usage()
    end if

    call get_command_argument( 1, param )
    read (param,*) n_x 

    call get_command_argument( 2, param )
    read (param,*) n_y 

    call get_command_argument( 3, param )
    read (param,*) iter_max

    call get_command_argument( 4, param )
    read (param,*) p_x

    call get_command_argument( 5, param )
    read (param,*) p_y

    if (p_x * p_y /= size_w)   then
        if (verbose) print *, 'the total number of processus differs from the product p_x * p_y ', & 
            & p_x, ' x ' , p_y , '/= ', size_w
        call MPI_FINALIZE( ierr )
        stop
    endif

    snapshot_step = 10
    snapshot_size = max(iter_max / snapshot_step, 1)
    allocate(solution(n_x, n_y, snapshot_size))

    call solve(n_x, n_y, p_x, p_y, snapshot_step, snapshot_size, iter_max, solution)

    call MPI_FINALIZE( ierr )

contains

    subroutine usage()
        implicit none
        character(len=255)::name

        call get_command_argument(0,name)
        print *, 'Usage: mpirun -np (p_x * p_y) ', TRIM(name), ' n_x n_y iter_max p_x p_y save_sol'
        print *, '    n_x       number of discretisation points in X'
        print *, '    n_y       number of discretisation points in Y'
        print *, '    iter_max  maximal number of iterations in temporal loop'
        print *, '    p_x       X process number'
        print *, '    p_y       Y process number'
        stop
    end subroutine usage

end program heat_main
