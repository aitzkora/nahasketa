module heat_solve
    public :: solve
contains

subroutine solve(n_x, n_y, p_x, p_y, snapshot_step, snapshot_size, iter_max, solution) bind( C, name="solve" )
  use iso_c_binding, only: c_int, c_double
  use communications
  use heat
  use mpi
  implicit none
  integer(c_int) :: n_x, n_y, p_x, p_y, snapshot_step, snapshot_size, iter_max
  real(c_double), dimension(n_x,n_y,snapshot_size) :: solution
  integer :: iter, size_x, size_y, ierr
  integer :: rank_w, size_w, rank_2D, comm2D, type_row, alloc_status
  integer, parameter :: ndims = 2, N = 1, S = 2, E = 3, W = 4
  logical :: is_master, reorder = .true.
  integer, dimension(4) :: neighbour
  real(c_double) :: h_x, h_y, d_t, error, error_loc, prec
  real(c_double), allocatable, dimension(:,:) ::  u_in,  u_out, sol_space

  integer, dimension(ndims) :: dims , coords
  logical, dimension(ndims) :: periods = .false.


  call MPI_COMM_RANK(MPI_COMM_WORLD, rank_w, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, size_w, ierr)

  is_master = (rank_w == 0)

  !if (is_master) then
  !print *, "n_x = ", n_x
  !print *, "n_y = ", n_y
  !print *, "p_x = ", p_x
  !print *, "p_x = ", p_y
  !print *, "snapshot_step = ", snapshot_step
  !print *, "snapshot_size = ", snapshot_size

  !end if
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

  ! Fetch the processus coordinates in the 2-D grid
  call MPI_CART_COORDS( comm2D, rank_2D, ndims, coords, ierr )

  ! Creation of a non-contiguous in memory column type
  ! to address Fortran storage: no stride of size_x
  call MPI_TYPE_VECTOR( size_y - 2, 1, size_x, MPI_DOUBLE_PRECISION, type_row, ierr )
  call MPI_TYPE_COMMIT( type_row, ierr )

  ! fetching the neighbor ranks
  call MPI_CART_SHIFT(COMM2D, 0, 1, neighbour( N ), neighbour( S ), ierr )
  call MPI_CART_SHIFT(COMM2D, 1, 1, neighbour( W ), neighbour( E ), ierr )

  allocate( u_in(size_x, size_y), stat=alloc_status )
  if (alloc_status /=0) stop "Not enough memory"
  allocate( u_out(size_x, size_y), stat=alloc_status )
  if (alloc_status /=0) stop "Not enough memory"

  prec = 1e-4
  error = 1e10
  !if (is_master) print '(5(16F5.2))' , pack(solution(:,:, :), .true.)
  u_in(:,:) = solution(:, :, 1)
  do iter= 0, iter_max

      !print '(i41x16F5.2)', rank_w,  pack(u_in, .true.)
  
      call stencil_4( h_x, h_y, d_t, u_in, u_out, error_loc )
      call MPI_ALLREDUCE( error_loc, error, 1, MPI_DOUBLE_PRECISION, MPI_SUM, MPI_COMM_WORLD, ierr )
      error = sqrt( error )

      if (is_master .and. mod( iter, snapshot_step ) == 0)  then
          print * , 'it =', iter, 't = ', iter * d_t, 'err = ', error
          allocate ( sol_space(n_x, n_y) )
          ! call gather_solution( sol_space, n_x, n_y, u_in, ndims, comm2D, is_master )
          solution(:, :, iter / snapshot_size) = sol_space
          deallocate( sol_space )
      end if

      call ghosts_swap( comm2D, type_row, neighbour, u_in )
      u_in = u_out
      if (error <= prec) exit
  end do

  ! We gather the solution on process 0

  deallocate( u_in )
  deallocate( u_out )

  call MPI_TYPE_FREE( type_row, ierr )

  end subroutine solve

end module heat_solve
