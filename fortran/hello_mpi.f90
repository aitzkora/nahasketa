! calculating pi with MPI
program hello
 !use mpi_f08
 implicit none
 include "mpif.h"
 
 integer :: rank, nprocs, ierr 
 call MPI_INIT( ierr )
 call MPI_COMM_RANK( MPI_COMM_WORLD, rank, ierr )
 call MPI_COMM_SIZE( MPI_COMM_WORLD, nprocs, ierr )
 
 print '(a(i2)a(i2)a)', "hello from ", rank, " among " , nprocs, " procs"
 
 call MPI_FINALIZE( ierr )
 
end program hello
