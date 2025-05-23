program skotx_direkt
  use iso_c_binding
  implicit none
  interface
    subroutine free_c(ptr) bind(c, name='free')
      use, intrinsic :: iso_c_binding, only: c_ptr
      type(c_ptr), value, intent(in) :: ptr
    end subroutine free_c
    subroutine exit_c(val) bind(c, name='exit')
      use, intrinsic :: iso_c_binding, only: c_int
      integer(c_int), value, intent(in) :: val
    end subroutine exit_c
  end interface

  integer, parameter :: is = SCOTCH_NUMSIZE


  include 'scotchf.h'

  integer ::                              i, argc
  type(c_ptr) ::                          xadj
  type(c_ptr) ::                          adjncy
  integer(is), pointer ::     xadj_f(:)
  integer(is), pointer ::     adjncy_f(:)

  integer(is), allocatable :: epart(:)
  integer(is), allocatable :: npart(:)
  integer(is) ::              nparts
  integer(is) ::              objval

  integer(is), parameter ::   baseval      = 1
  integer(is), parameter ::   ne           = 6
  integer(is), parameter ::   nn           = 7
  integer(is) ::              eptr(7)      = [ 0, 3, 6, 9, 12, 15, 18 ]
  integer(is) ::              eind(18)     = [ 0, 1, 2, 0, 1, 5, 1, 5, 4, 1, 4, 6, 1, 6, 3, 1, 3, 2 ]
  integer(is) ::              xadj_c(7)    = [ 0, 5, 10, 15, 20, 25, 30 ]
  integer(is) ::              adjncy_c(30) = [ 1, 2, 3, 4, 5, 0, 2, 3, 4, 5, 0, 1, 3, 4, 5, 0, 1, 2, 4, 5, 0, &
                                                           1, 2, 3, 5, 0, 1, 2, 3, 4 ]

  integer(is) ::              options(METIS_NOPTIONS)

  integer(is) ::              ncommon = 1
  real(c_double)          ::              meshptr

  allocate (epart(ne))
  allocate (npart(nn))

  eind (:)     = eind (:)     + baseval
  eptr (:)     = eptr (:)     + baseval
  xadj_c (:)   = xadj_c (:)   + baseval
  adjncy_c (:) = adjncy_c (:) + baseval


  metis_to_mesh(
  !call scotchfmeshbuild(meshptr, baseval, nn, eptr, eind, ncommon, baseval, xadj, adjncy)
  !call scotchfmeshbuild(ne, nn, eptr, eind, ncommon, baseval, xadj, adjncy)
  !if (.not. c_associated (xadj)) then
  !  print *, "ERROR: main: error in METIS_MeshToDual"
  !  call exit_c (1)
  !end if

  !call c_f_pointer (xadj, xadj_f, [7])            ! convert c_pointers to fortran arrays
  !call c_f_pointer (adjncy, adjncy_f, [30])

  !do i = 1, 7
  !  if (xadj_f(i) /= xadj_c(i)) then
  !    print *, "ERROR: main: invalid vertex array"
  !    call exit_c (1)
  !  end if
  !end do
  !do i = 1, 30
  !  if (adjncy_f(i) /= adjncy_c(i)) then
  !    print *, "ERROR: main: invalid edge array"
  !    call exit_c (1)
  !  end if
  !end do

  !! free c pointers calling the stdlib free function
  !call free_c (xadj)
  !call free_c (adjncy)


  !deallocate (npart)
  !deallocate (epart)

contains 

   subroutine metis_to_mesh(edgetab, edgenbr, srcverttab , ne , nn, vnodnbr, eptr, eind, baseval)
     integer(is), allocatable, intent(out) :: edgetab(:)
     integer(is), intent(out) :: edgenbr
     integer(is), intent(in) :: ne 
     integer(is), intent(in) :: nn 
     integer(is), intent(in) :: eptr(baseval:baseval+ne)      
     integer(is), intent(in) :: eind(*)
     integer(is), intent(in) :: baseval
     integer(is) :: vertnum, degrmax, edgeadj
     integer(is), allocatable :: srcverttax(:)

     allocate(srcverttax(0:nn+ne))
     srcverttax(ne:) = 0
     degrmax = 0
     edgenbr = 0
     do vertnum= baseval, baseval+velmnbr-1
       block
         integer(is) :: edgenum, edgennd, degrval, ind
         edgenum = eptr(vertnum)
         edgennd = eptr(vertnum+1)
         degrval = edgennd - edgenum
         if (degrval > degrmax) then degrmax = degrval
         edgenbr = edgenbr + degrval
         EDGENUM : do 
           ind = ne + eind(edgenum -baseval) !BEWARE : eind is basevaled or not ???
           srcverttax(ind) = srcverttax(ind) + 1
           edgenum = edgenum  + 1
         end do EDGENUM
       end block
     end do

     edgenbr = edgenbr * 2
    
     if (eptr(baseval) = baseval) then
       srcverttax(baseval:baseval+nn-1) = eptr(baseval:baseval+nn-1)
     else
       edgeadj = eptr(baseval) - baseval
       do vertnum = baseval, baseval + ne -1
         srcverttax(vertnum) = eptr(vertnum) + edgeadj
       end do
     end if

     edgenum = eptr(ne + baseval)
     do vertnum = baseval + ne, ne + baseval + nn
       block
         integer(is):: degrval
         degrval = srcverttax(vertnum)
         if (degrval > degrmax) then degrmax = degrval
         srcverttax(vertnum) = edgenum
         edgenum = edgenum + degrval
       end block
     end do
     srcverttax(vertnum) = edgenum
     allocate(srcedgetax(0:edgenbr-1))

     do edgenum = baseval, eptr(ne+baseval)-1
       srcedgetax(edgenum) = edgetax(edgenum) + ne
     end do

     do vertnum = baseval, ne+ baseval -1
       do edgenum = eptr(vertnum), eptr(vertnum + 1)
         srcedgetax(srcverttax(edgetax(edgenum) + ne ) ) = vertnum
         srcverttax(edgetax(edgenum) + ne ) = 
         srcverttax(edgetax(edgenum) + ne ) + 1
       end do
     end do

     srcverttax(ne+baseval:ne+baseval+nn-2)
     srcverttax(ne+baseval) = eptr(ne+baseval)

   end subroutine metis_to_mesh


end program skotx_direkt
