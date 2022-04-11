program debug_scotch

  implicit none
  include "mpif.h"
  include "ptscotchf.h"

  integer :: rank, is_init, ierr

  real(kind(1.d0)) :: grafdat(SCOTCH_DGRAPHDIM)
  integer(kind=SCOTCH_INTSIZE) :: baseval
  integer(kind=SCOTCH_INTSIZE) :: vertlocnbr
  integer(kind=SCOTCH_INTSIZE) :: edgelocnbr
  integer(kind=SCOTCH_INTSIZE), dimension(:), allocatable :: graph_xadj
  integer(kind=SCOTCH_INTSIZE), dimension(:), allocatable :: graph_adjncy

  integer, parameter :: N_GLOB = 40

  call mpi_init_thread(MPI_THREAD_MULTIPLE, is_init, ierr)
  call mpi_comm_rank(MPI_COMM_WORLD, rank, ierr)

  baseval = 1

  print *, "scotchfdgraphinit"
  call scotchfdgraphinit(grafdat(1), MPI_COMM_WORLD, ierr)

  print *, "baseval overwritten ?", baseval
  baseval = 1
  print *, "baseval reset", baseval

  if(rank == 0) then
     vertlocnbr = 20
     edgelocnbr = 39

     allocate(graph_xadj(vertlocnbr+1))
     graph_xadj(:) = (/1,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,&
          32,34,36,38,40/)

     allocate(graph_adjncy(edgelocnbr))
     graph_adjncy(:) = (/2,1,3,2,4,3,5,4,6,5,7,6,8,7,9,8,10,9,11,10,&
          12,11,13,12,14,13,15,14,16,15,17,16,18,17,19,18,20,19,21/)
  else
     vertlocnbr = 20
     edgelocnbr = 39

     allocate(graph_xadj(vertlocnbr+1))
     graph_xadj(:) = (/1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,&
          33,35,37,39,40/)

     allocate(graph_adjncy(edgelocnbr))
     graph_adjncy(:) = (/20,22,21,23,22,24,23,25,24,26,25,27,26,28,27,&
          29,28,30,29,31,30,32,31,33,32,34,33,35,34,36,35,37,36,38,37,39,38,40,39/)
  endif

  print *, "scotchfdgraphbuild"
  call scotchfdgraphbuild(grafdat(1),baseval,&
       vertlocnbr,vertlocnbr,graph_xadj,graph_xadj(2:),graph_xadj,graph_xadj,&
       edgelocnbr,edgelocnbr,graph_adjncy,graph_adjncy,graph_adjncy,&
       ierr)

  print *, "scotchfdgraphcheck"
  call scotchfdgraphcheck(grafdat(1), ierr)

  call mpi_barrier(MPI_COMM_WORLD, ierr)

  call scotchfdgraphexit(grafdat(1),ierr)

  call mpi_finalize(ierr)

end program debug_scotch
