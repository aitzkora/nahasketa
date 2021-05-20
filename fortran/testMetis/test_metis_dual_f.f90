program test_metis_dual
  use iso_c_binding
  implicit none
 interface
   subroutine free_c_ptr(ptr) bind(c, name='free')
      use, intrinsic :: iso_c_binding, only: c_ptr
      type(c_ptr), value, intent(in) :: ptr
  end subroutine free_c_ptr
  end interface

 integer ::              i, argc
  type(c_ptr) ::          xadj
  type(c_ptr) ::          adjncy
  integer, pointer ::     xadj_f(:)
  integer, pointer ::     adjncy_f(:)

  integer, allocatable :: epart(:)
  integer, allocatable :: npart(:)
  integer  ::             nparts
  integer  ::             objval
  integer, pointer ::     vsize

  integer, parameter ::   ne = 6, nn = 7

  integer ::              eptr(7) = [ 0, 3, 6, 9, 12, 15, 18]
  integer ::              eind(18) = [ 0, 1, 2, 0, 1, 5, 1, 5, 4, 1, 4, 6, 1, 6, 3, 1, 3, 2]
  integer ::              xadj_c(7) = [ 0, 5, 10, 15, 20, 25, 30]
  integer ::              adjncy_c(30) = [1, 2, 3, 4, 5, 0, 2, 3, 4, 5, 0, 1, 3, 4, 5, 0, 1, 2, 4, 5, 0, 1, 2, 3, 5, 0, 1, 2, 3, 4]

  integer, parameter :: metis_noptions = 40
  integer :: options(metis_noptions)
  integer, parameter :: metis_option_numbering = 17


  integer :: baseval = 1
  integer :: ncommon = 1
  character(len=32) :: arg1

  


  allocate(epart(ne))
  allocate(npart(nn))
 
  argc =  command_argument_count()
  if (argc >= 1) then
    call get_command_argument(1, arg1)
    read (arg1, '(i5)') baseval
    print *, 'baseval = ', baseval
  end if 

  eind(:) = eind(:) + baseval
  eptr(:) = eptr(:) + baseval
  xadj_c(:) = xadj_c(:) + baseval
  adjncy_c(:) = adjncy_c(:) + baseval

  call METIS_MeshToDual (ne, nn, eptr, eind, ncommon, baseval, xadj, adjncy)

  call c_f_pointer( xadj, xadj_f, [7])
  call c_f_pointer( adjncy, adjncy_f, [30])


  do i = 1, 7
    if (xadj_f(i) /= xadj_c(i)) then 
      print *, "ERROR adj : ", i
      stop -1
    end if
  end do
  do i = 1, 30
    if (adjncy_f(i) /= adjncy_c(i)) then 
      print * , "ERROR adjncy :", i
      stop -1
    end if
  end do
  call free_c_ptr (xadj)
  call free_c_ptr (adjncy)

  if (baseval == 1) then
    block
      !real(kind=8) :: tpwgt(3) = [0.75, 0.125, 0.125]
      !integer :: vgwt(6) = [1, 2, 1, 1, 1, 1]
      real(kind=4), pointer :: tpwgt => null()
      integer, pointer :: vgwt => null()
      nparts = 3
      ncommon = ncommon + 1 
      options(:) = 0 
      options(8) = 1  
      options(16) = 1  
      options(7) = 10
      options(metis_option_numbering) = 1
      call METIS_PartMeshDual( ne, nn, eptr, eind, vgwt, vsize, ncommon, nparts, tpwgt, options, objval, epart, npart)
      print * , epart
    end block
  end if 

  deallocate (npart)
  deallocate (epart)
  
end program test_metis_dual
