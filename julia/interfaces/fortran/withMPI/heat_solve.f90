module heat_solve
    public :: solve
    private :: set_bounds
contains

subroutine solve(n_x, n_y, p_x, p_y, snapshot_step, snapshot_size, iter_max, solution) bind( C, name="solve" )
  use iso_c_binding, only: c_int32_t, c_double
  use iso_fortran_env, only: error_unit
  use communications
  use heat
  use mpi
  implicit none
  integer(c_int32_t), intent(in) :: n_x, n_y ! sizes of the global matrix
  integer(c_int32_t), intent(in) :: p_x, p_y ! nb of processes (in each dimensions)
  integer(c_int32_t), intent(in) :: snapshot_step, snapshot_size
  integer(c_int32_t), intent(inout) ::  iter_max ! max number of iterations
  real(c_double), intent(inout) :: solution(1:n_x, 1:n_y, 1:snapshot_size)

  integer(c_int32_t) :: i, size_x, size_y, ierr
  integer(c_int32_t) :: rank_w, size_w, rank_2D, comm2D, type_row
  integer(c_int32_t), parameter :: ndims = 2, N = 1, S = 2, E = 3, W = 4
  logical :: is_master, reorder = .true.
  integer(c_int32_t), dimension(4) :: neighbour
  real(c_double) :: h_x, h_y, d_t, error, error_loc, prec
  real(c_double), allocatable, dimension(:,:) ::  u_in,  u_out, sol_space

  integer(c_int32_t), dimension(ndims) :: dims , coords
  logical, dimension(ndims) :: periods = .false.


  call MPI_COMM_RANK(MPI_COMM_WORLD, rank_w, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, size_w, ierr)

  is_master = (rank_w == 0)

  size_x = 2 + n_x / p_x
  size_y = 2 + n_y / p_y

  h_x = 1.d0 / n_x
  h_y = 1.d0 / n_y
  d_t = min( h_x * h_x / 4.d0, h_y * h_y / 4.d0)

  ! construction of the cartesion topology
  dims(1) = p_x
  dims(2) = p_y

  call MPI_CART_CREATE( MPI_COMM_WORLD, ndims, dims, periods, reorder, comm2D, ierr )
  call MPI_COMM_RANK( comm2D, rank_2D, ierr )

  !! Fetch the processus coordinates in the 2-D grid
  call MPI_CART_COORDS( comm2D, rank_2D, ndims, coords, ierr )

  !! Creation of a non-contiguous in memory column type
  !! to address Fortran storage: no stride of size_x
  call MPI_TYPE_VECTOR( size_y - 2, 1, size_x, MPI_DOUBLE_PRECISION, type_row, ierr )
  call MPI_TYPE_COMMIT( type_row, ierr )

  !! fetching the neighbor ranks
  call MPI_CART_SHIFT(COMM2D, 0, 1, neighbour( N ), neighbour( S ), ierr )
  call MPI_CART_SHIFT(COMM2D, 1, 1, neighbour( W ), neighbour( E ), ierr )

  allocate( u_in(size_x, size_y) ) ! not class : we do not look at alloc status
  allocate( u_out(size_x, size_y) )

  prec = 1e-4
  error = 1e10
  call set_bounds( coords, p_x, p_y, u_in)
  call set_bounds( coords, p_x, p_y, u_out)

  do i=1, iter_max

      call stencil_4( h_x, h_y, d_t, u_in, u_out, error_loc )
      call MPI_ALLREDUCE( error_loc, error, 1, MPI_DOUBLE_PRECISION, MPI_SUM, MPI_COMM_WORLD, ierr )
      error = sqrt( error )

      if (mod( i, snapshot_step ) == 0)  then
          if (is_master) print * , 'it =', i, 't = ', i * d_t, 'err = ', error
          allocate ( sol_space(n_x, n_y) )
          call gather_solution( sol_space, n_x, n_y, u_in, ndims, comm2D, is_master )
          if (is_master) solution(:, :, i / snapshot_step) = sol_space(:, :)
          deallocate( sol_space )
      end if

      call ghosts_swap( comm2D, type_row, neighbour, u_in )
      u_in = u_out
      if (error <= prec) exit
  end do

  MAX_IT: if (i < iter_max ) then
      iter_max = i ! to know if we do all loops
  else
      if (is_master) write(error_unit, '(ai0a)') "max number of iterations (", iter_max, ") reached"
  end if MAX_IT
  ! We gather the solution on process 0

  deallocate( u_in )
  deallocate( u_out )

  call MPI_TYPE_FREE( type_row, ierr )

  end subroutine solve

  subroutine set_bounds(coo, p_x, p_y, u)

        implicit none
        integer, intent(in) :: p_x, p_y
        integer, dimension(2), intent(in) :: coo
        real(kind=8), dimension(:, :), intent(out) :: u
        u = 0.d0
        if (coo(1) == 0)          u(1,      :) = 1.d0
        if (coo(1) == (p_x - 1)) u(size( u, 1 ), :) = 1.d0

        if (coo(2) == 0)          u(:,      1) = 1.d0
        if (coo(2) == (p_y - 1)) u(:, size( u, 2 ) ) = 1.d0

    end subroutine set_bounds

end module heat_solve
