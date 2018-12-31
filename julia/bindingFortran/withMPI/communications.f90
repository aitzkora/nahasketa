module communications
public :: ghosts_swap, gather_solution

contains

subroutine ghosts_swap(comm, type_row, neighbour, u)
  use iso_c_binding, only: c_int64_t, c_double
  use mpi
  implicit none
  integer(c_int64_t), intent(in) :: comm, type_row
  integer(c_int64_t), dimension(4), intent(in) :: neighbour
  real(c_double), dimension(:, :), intent(inout) :: u
  integer(c_int64_t), parameter ::  N  = 1, S = 2, E = 3, W = 4
  integer(c_int64_t) :: ierr, s_tag, r_tag
  integer(c_int64_t), dimension(MPI_STATUS_SIZE) :: stat

  ! N --> S
  !  N block last significant row goes to S block first ghost row
  s_tag =0; r_tag = 0
  call MPI_Sendrecv(u(size( u, 1 ) - 1, 2),  1, type_row, neighbour(S), s_tag, &
  &                 u(1, 2) , 1, type_row, neighbour(N), r_tag, comm, stat, ierr)

  ! S --> N
  ! S block first significant row  goes to N block last ghost row 
  s_tag =1; r_tag = 1
  call MPI_Sendrecv(u(2, 2),  1, type_row, neighbour(N), s_tag, &
  &                 u(size( u, 1 ) , 2), 1, type_row, neighbour(S), r_tag, comm, stat, ierr)

  ! W --> E
  ! W block last significant column goes to E block first ghost column
  s_tag =2; r_tag = 2
  call MPI_Sendrecv(u(1, size( u, 2 ) - 1), size( u, 1 ), MPI_DOUBLE_PRECISION, neighbour(E), s_tag,&
  &                 u(1, 1) , size( u, 1 ), MPI_DOUBLE_PRECISION, neighbour(W), r_tag, comm, stat, ierr)

  !  E --> W
  !  E block first significant column goes to W block last ghost column
  s_tag =3; r_tag = 3
  call MPI_Sendrecv(u(1, 2), size( u, 1 ) , MPI_DOUBLE_PRECISION, neighbour(W), s_tag, &
  &                 u(1, size( u, 2 )) , size( u, 1 ), MPI_DOUBLE_PRECISION, neighbour(E), r_tag, comm, stat, ierr)

end subroutine ghosts_swap

subroutine gather_solution(sol, n_x, n_y, u, ndims, comm2D, is_master)
     use iso_c_binding, only: c_int64_t, c_double
     use mpi
     implicit none
     real(c_double), dimension(:,:), intent(in) , contiguous :: u
     real(c_double), dimension(:,:), intent(inout) :: sol
     integer(c_int64_t),  intent(in) :: comm2D, ndims, n_x, n_y
     logical :: is_master

     real(c_double), allocatable, dimension (:) :: vec_temp, u_vec
     integer :: cell_x , cell_y, rank, ierr, size_w
     integer(c_int64_t), dimension(ndims) :: coo

     cell_x = size( u, 1 ) - 2
     cell_y = size( u, 2 ) - 2
     if (is_master) allocate( vec_temp(n_x * n_y) )

     allocate( u_vec(cell_x * cell_y) )

     u_vec = reshape( u(2:size( u, 1 ) - 1, 2:size( u, 2) - 1), [size( u_vec )])
     call MPI_GATHER( u_vec , size( u_vec ) , MPI_DOUBLE_PRECISION, &
                  vec_temp, size( u_vec ), MPI_DOUBLE_PRECISION, 0, MPI_COMM_WORLD, ierr )

    if (is_master) then
     sol  = reshape( vec_temp, [n_x, n_y] )
     call MPI_COMM_SIZE(MPI_COMM_WORLD, size_w, ierr)
     do rank = 1, size_w
        call MPI_CART_COORDS( comm2D, rank - 1, ndims, coo, ierr )
        sol(coo(1) * cell_x + 1:(coo(1)+1) * cell_x, coo(2) * cell_y + 1:(coo(2)+1) * cell_y) = &
        reshape( vec_temp(cell_x * cell_y * (rank - 1) + 1: cell_x * cell_y * rank), [cell_x, cell_y] )
     end do
 end if
     deallocate( u_vec )
     if (is_master) deallocate( vec_temp )

end subroutine gather_solution

end module communications
