program test_build
  use iso_c_binding
  implicit none
  include 'scotchf.h'
  integer :: baseval, edgenbr
  integer :: ncell, nnode, ncommon, nproc
  integer :: ierr
  integer(SCOTCH_NUMSIZE), allocatable :: connectivity(:), & 
                                          cell_node_counter(:), &
                                          metis_corres(:), &
                                          ndofs(:)

  real(c_double)       :: meshdat(SCOTCH_MESHDIM)
  real(c_double)       :: grafdat(SCOTCH_GRAPHDIM)
  real(c_double)       :: stradat(SCOTCH_STRATDIM)

  baseval = 0 
  ncell = 8202
  nnode = 4282
  ncommon = 2
  nproc = 4

  call read_vec("verttab.bin", cell_node_counter, ncell + 1)
  call read_vec("edgetab.bin", connectivity, cell_node_counter(ncell+1))
  call read_vec("edlotab.bin", ndofs, ncell)

  allocate(metis_corres(ncell))
  
  edgenbr = cell_node_counter(ncell) - baseval
  call scotchfmeshinit(meshdat(1), ierr)
  call scotchfmeshbuildelem(meshdat(1), &
                            baseval, & ! zero-based numbering
                            baseval, & ! zero-based numbering
                            ncell, &
                            nnode, &
                            cell_node_counter(1), & ! verttab
                            cell_node_counter(2), & !compact storage
                            cell_node_counter(1), & !NULL
                            cell_node_counter(1), & !NULL
                            cell_node_counter(1), & !NULL
                            edgenbr, &
                            connectivity(1), &
                            ierr) ! edgetab

  call scotchfgraphinit(grafdat(1), ierr)
  ! build element's graph
  call scotchfmeshgraphdual(meshdat(1), &
                            grafdat(1), &
                            ncommon, &
                            ierr)
  call scotchfstratinit(stradat(1), ierr)
  call scotchfgraphpart(grafdat(1), &
                          nproc, &
                          stradat(1), &
                          metis_corres, &
                          ierr)

  ! cleaning scotch's structures
  call scotchfstratexit(stradat)
  call scotchfmeshexit(meshdat)
  call scotchfgraphexit(grafdat)

  deallocate(connectivity)
  deallocate(cell_node_counter)
  deallocate(metis_corres)

contains

  subroutine read_vec(filename, vec, length)
     character(len=*), intent(in) :: filename
     integer(SCOTCH_NUMSIZE), allocatable, intent(inout) :: vec(:)
     integer, intent(in) :: length
     allocate(vec(length))
     open(unit=22, file=filename, action="read", form ='unformatted', access='stream', err=10)
     read (22, err=11) vec 
     close(22)
     return
  10 print *, "file " // trim(filename) // " not found! "
     stop -1
  11 print *, "could not read the vec!"
     stop -1
  end subroutine read_vec


end program test_build
