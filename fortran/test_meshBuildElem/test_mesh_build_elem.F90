program test_build
  use iso_c_binding
  implicit none
  include 'scotchf.h'
  integer :: baseval, edgenbr
  integer :: ncell, nnode, ncommon, nproc
  integer :: ierr
  integer(SCOTCH_NUMSIZE), allocatable :: connectivity(:), & 
                                          cell_node_counter(:), &
                                          metis_corres(:)

  real(c_double)       :: meshdat(SCOTCH_MESHDIM)
  real(c_double)       :: grafdat(SCOTCH_GRAPHDIM)
  real(c_double)       :: stradat(SCOTCH_STRATDIM)

  baseval = 0 
  ncell = 8202
  nnode = 4282
  ncommon = 2
  nproc = 4
  allocate(cell_node_counter(ncell+1))
  open(unit=22, file="verttab.bin", action="read", form ='unformatted', access='stream')
  read (22) cell_node_counter
  close(22)

   
  allocate(connectivity(cell_node_counter(ncell+1)))
  open(unit=22, file="edgetab.bin", action="read", form ='unformatted', access='stream')
  read (22) connectivity
  close(22)

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
end program test_build
