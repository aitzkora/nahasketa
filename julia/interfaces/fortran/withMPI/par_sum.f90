program par_sum
   use mpi
   implicit none
   integer :: n  ! size of the array
   integer, allocatable :: x(:)
   character(len=18) :: param
   integer :: i, code, nb_procs, rank
   integer :: sum_loc 
   integer :: sum_tot = 0 ! sum result
   integer :: slice(2)

   call MPI_INIT(code)
   call get_command_argument( 1, param )
   read (param,*) n
   allocate(x(n))
   x = [(i, i=1,n)]
   call MPI_COMM_SIZE( MPI_COMM_WORLD, nb_procs, code)
   call MPI_COMM_RANK( MPI_COMM_WORLD, rank, code)
   ! computing slices
   slice = compute_slice(n, nb_procs, rank)
   sum_loc = sum(x(slice(1):slice(2)))

   call MPI_reduce(sum_loc, sum_tot, 1, MPI_INTEGER, MPI_SUM, 0, MPI_COMM_WORLD, code)
   if (rank == 0) print * , sum_tot

   call MPI_FINALIZE( code)

contains
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

end program par_sum
