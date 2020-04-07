program coucou
  use mpi
  implicit none
  integer :: world_rank, ierr

  call MPI_Init(ierr)
  call MPI_Comm_rank(MPI_COMM_WORLD, world_rank, ierr)
  print '(ai0a)', "Coucou depuis ", world_rank, " !"
  call MPI_Finalize(ierr)
end program 
