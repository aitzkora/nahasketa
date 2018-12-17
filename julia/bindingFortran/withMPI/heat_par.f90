program heat_par
  include 'mpif.h'
  public :: heat
contains
  subroutine heat(nx, ny, p_x, p_y, iter_max, snapshot_step, solution) bind( C, name="heat" )
  implicit none
  integer, intent(in) :: nx, ny, p_x, p_y, iter_max, snapshot_step
  integer :: i, cell_x, cell_y, size_x, size_y, ierr
  integer, parameter :: ndims = 2
  integer :: rank_w, size_w, rank_2D, comm2D, type_row , alloc_status, narg
  integer :: N=1, S = 2, E = 3, W = 4
  logical :: verbose, reorder = .true.
  integer, dimension(4) :: neighbour
  real(c_double) :: hx, hy, dt, error, error_loc, prec
  real(c_double), allocatable ::  u_in(:,:), u_out(:,:), vec_temp(:), u_vec(:)
  real(c_double), intent(out) :: solution(:,:,:)
  integer, dimension(ndims) :: dims , coords, coo
  logical, dimension(ndims) :: periods = .false.


  cell_x = nx / p_x
  cell_y = ny / p_y

  size_x = cell_x + 2
  size_y = cell_y + 2

  hx = 1.d0/ nx
  hy = 1.d0/ ny
  dt = min(hx*hx/4.d0, hy*hy/4.d0)

  ! construction of the cartesion topology
  dims(1) = p_x
  dims(2) = p_y

  call MPI_Cart_create(MPI_COMM_WORLD, ndims, dims, periods, reorder, comm2D, ierr) 
  call MPI_Comm_rank(comm2D, rank_2D, ierr)


  ! Fetch the processus coordinates in the 2-D grid
  call MPI_Cart_coords(comm2D, rank_2D, ndims, coords, ierr)

  ! Creation of a non-contiguous in memory column type
  ! to address Fortran storage: no stride of size_x
  call MPI_Type_vector(cell_y, 1, size_x, MPI_DOUBLE_PRECISION, type_row, ierr)
  call MPI_Type_commit(type_row, ierr)

  ! fetching the neighbor ranks
  call MPI_Cart_shift(comm2D, 0, 1, neighbour(N), neighbour(S), ierr)
  call MPI_Cart_shift(comm2D, 1, 1, neighbour(W), neighbour(E), ierr)

  allocate(u_in(1:size_x,1:size_y), stat=alloc_status)
  if (alloc_status /=0) stop "Not enough memory"
  allocate(u_out(1:size_x,1:size_y), stat=alloc_status)
  if (alloc_status /=0) stop "Not enough memory"

  call set_bounds(coords, p_x, p_y, size_x, size_y, u_in)
  call set_bounds(coords, p_x, p_y, size_x, size_y, u_out)


  prec = 1e-4
  error = 1e10
  do i=0, iter_max

      call heat(hx, hy, dt, size_x, size_y, u_in, u_out, error_loc)
      call MPI_Allreduce(error_loc, error, 1, MPI_DOUBLE_PRECISION, MPI_SUM, MPI_COMM_WORLD, ierr)
      error = sqrt(error)

      if (mod( i, snapshot_step) == 0)
      if (verbose) print * , 'it =', i, 't = ', i*dt, 'err = ', error



      end if
      u_in = u_out
      call ghosts_swap(comm2D, type_row, neighbour, size_x, size_y, u_in)
      if (error <= prec) exit 

  end do 

  ! We gather the solution on process 0
  if 
  if (verbose) then
    allocate(vec_temp(1:nx * ny))
  end if
  allocate(u_vec(1:cell_x * cell_y))
  u_vec = reshape( u_in(2:size_x - 1, 2:size_y - 1), [cell_x * cell_y] )
  call MPI_Gather( u_vec , cell_x * cell_y , MPI_DOUBLE_PRECISION, &
                  vec_temp, cell_x * cell_y, MPI_DOUBLE_PRECISION, 0, MPI_COMM_WORLD, ierr )

  if (verbose) then
    solution(:, :, snapshot_time) = reshape( vec_temp, [nx, ny] )
    do rank_w=1,size_w
        call MPI_Cart_coords( comm2D, rank_w-1, ndims, coo, ierr )
        solution(coo(1) * cell_x + 1:(coo(1)+1) * cell_x, &
                 coo(2) * cell_y + 1:(coo(2)+1) * cell_y, snapshot_time) = &
        reshape( vec_temp(cell_x * cell_y * (rank_w - 1) + 1: cell_x * cell_y * rank_w), [cell_x, cell_y] )
    end do 
    !do i=1,nx
    !    print *, (real(solution(i,j)), j=1,ny)
    !enddo
    deallocate(vec_temp)
  end if

  deallocate(u_vec)
  deallocate(u_in)
  deallocate(u_out)

  call MPI_Type_free(type_row, ierr)
  call MPI_Finalize(ierr)

end subroutine heat

subroutine ghosts_swap(comm, type_row, neighbour, size_x, size_y, u)

  integer, intent(in) :: size_x, size_y, comm, type_row
  integer, dimension(4), intent(in) :: neighbour
  real(c_double), dimension(1:size_x, 1:size_y), intent(inout) :: u
  integer, parameter ::  N  = 1, S = 2, E = 3, W = 4
  integer :: ierr, s_tag, r_tag
  integer, dimension(MPI_STATUS_SIZE) :: stat

  ! N --> S
  !  N block last significant row goes to S block first ghost row
  s_tag =0; r_tag = 0
  call MPI_Sendrecv(u(size_x - 1, 2),  1, type_row, neighbour(S), s_tag, &
  &                 u(1, 2) , 1, type_row, neighbour(N), r_tag, comm, stat, ierr)

  ! S --> N
  ! S block first significant row  goes to N block last ghost row
  s_tag =1; r_tag = 1
  call MPI_Sendrecv(u(2, 2),  1, type_row, neighbour(N), s_tag, &
  &                 u(size_x , 2), 1, type_row, neighbour(S), r_tag, comm, stat, ierr)

  ! W --> E
  ! W block last significant column goes to E block first ghost column
  s_tag =2; r_tag = 2
  call MPI_Sendrecv(u(1, size_y - 1), size_x, MPI_DOUBLE_PRECISION, neighbour(E), s_tag,&
  &                 u(1, 1) , size_x, MPI_DOUBLE_PRECISION, neighbour(W), r_tag, comm, stat, ierr)

  !  E --> W
  !  E block first significant column goes to W block last ghost column
  s_tag =3; r_tag = 3
  call MPI_Sendrecv(u(1, 2), size_x , MPI_DOUBLE_PRECISION, neighbour(W), s_tag, &
  &                 u(1, size_y) , size_x, MPI_DOUBLE_PRECISION, neighbour(E), r_tag, comm, stat, ierr)

end subroutine ghosts_swap

subroutine set_bounds(coo, p_x, p_y, size_x, size_y, u)

  implicit none
  integer, intent(in) :: size_x, size_y, p_x, p_y
  integer, dimension(2), intent(in) :: coo
  real(c_double), dimension(1:size_x, 1:size_y), intent(out) :: u
  u = 0.d0
  if (coo(1) == 0)          u(1,      :) = 1.d0
  if (coo(1) == (p_x - 1)) u(size_x, :) = 1.d0

  if (coo(2) == 0)          u(:,      1) = 1.d0
  if (coo(2) == (p_y - 1)) u(:, size_y) = 1.d0

end subroutine set_bounds

end module heat_par
