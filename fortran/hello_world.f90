program helloworld
  use mpi
  implicit none
  integer rank, size, ierror, tag, status(MPI_STATUS_SIZE)
  call MPI_INIT(ierror)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierror)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierror)
  print*, 'Rank', rank, ': Hello world!'
  call MPI_FINALIZE(ierror)
end program helloworld
