program skotx_direkt
  use iso_c_binding
  implicit none

  include 'scotchf.h'
  integer, parameter :: is = SCOTCH_NUMSIZE

  type(c_ptr) ::              xadj
  type(c_ptr) ::              adjncy

  integer(is), allocatable :: epart(:)
  integer(is), allocatable :: npart(:)
  integer(is) ::              nparts
  integer(is) ::              objval
  integer(is), allocatable :: edgetab
  integer(is)              :: edgenbr

  integer(is), parameter ::   baseval      = 1
  integer(is), parameter ::   ne           = 6
  integer(is), parameter ::   nn           = 7
  integer(is) ::              eptr(7)      = [ 0, 3, 6, 9, 12, 15, 18 ]
  integer(is) ::              eind(18)     = [ 0, 1, 2, 0, 1, 5, 1, 5, 4, 1, 4, 6, 1, 6, 3, 1, 3, 2 ]
  integer(is) ::              xadj_c(7)    = [ 0, 5, 10, 15, 20, 25, 30 ]
  integer(is) ::              adjncy_c(30) = [ 1, 2, 3, 4, 5, 0, 2, 3, 4, 5, 0, 1, 3, 4, 5, 0, 1, 2, 4, 5, 0, &
                                               1, 2, 3, 5, 0, 1, 2, 3, 4 ]

  type :: mesh_scotch 
     integer(is)              :: velmbas
     integer(is)              :: vnodbas
     integer(is)              :: velmnbr
     integer(is)              :: vnodnbr
     integer(is), allocatable :: verttab(:)
     integer(is), allocatable :: vendtab(:)
     integer(is), allocatable :: velotab(:)
     integer(is), allocatable :: vnlotab(:)
     integer(is), allocatable :: vlbltab(:)
     integer(is)              :: edgenbr
     integer(is), allocatable :: edgetab(:)
  end type mesh_scotch

  
  type(mesh_scotch) :: mesh



  allocate (epart(ne))
  allocate (npart(nn))

  eind (:)     = eind (:)     + baseval
  eptr (:)     = eptr (:)     + baseval

  call metis_to_mesh(mesh, baseval, nn, ne, eptr, eind)

contains 

   subroutine metis_to_mesh(mesh, baseval, vnodnbr, velmnbr, verttab, edgetab)
     type(mesh_scotch), intent(out) :: mesh
     integer(is), intent(in) :: baseval
     integer(is), intent(in) :: vnodnbr , velmnbr
     integer(is), intent(in) :: verttab(baseval:velmnbr+baseval) ! beware : velmnbr+1
     integer(is), intent(in) :: edgetab(:)

     integer(is) :: vertnum, degrmax, edgeadj
     integer(is), allocatable :: srcverttax(:)
     integer(is) :: edgechk 



     allocate(srcverttax(baseval:vnodnbr+velmnbr+baseval-1))

     edgechk = verttab(velmnbr+baseval)
     print '(a,i0)', "edgecheck = ", edgechk
#ifndef NDEBUG
     if ((lbound(edgetab, 1) /= baseval) .or. (ubound(edgetab,1) /= (edgechk-1))) then
        print "(a,i0,a,i0,a)", "edgetab(",lbound(edgetab, 1), ":", ubound(edgetab,1),")"
        stop "bad bounds for edgtab"
     endif
#endif
     srcverttax(velmnbr:) = 0
     degrmax = 0
     edgenbr = 0
     ! we want to compute the edgenbr
     ! loop on elems
     do vertnum= baseval, baseval+velmnbr-1
       block
         integer(is) :: edgenum, edgennd, degrval, ind
         edgenum = verttab(vertnum)
         edgennd = verttab(vertnum+1)
         degrval = edgennd - edgenum
         if (degrval > degrmax) then 
           degrmax = degrval
         end if
         edgenbr = edgenbr + degrval
         EDGE : do 
           if (edgenum == edgennd) exit
           ind = velmnbr + eind(edgenum) 
           srcverttax(ind) = srcverttax(ind) + 1
           edgenum = edgenum  + 1
         end do EDGE
       end block
     end do

#ifndef NDEBUG
     if (edgenbr /= edgechk-baseval) stop "error in computation of edgenbr"
#endif
     edgenbr = edgenbr * 2
   
     print '(a,i0)', "edgenbr = ", edgenbr

     if (eptr(baseval) = baseval) then
       srcverttax(baseval:baseval+vnodnbr-1) = eptr(baseval:baseval+vnodnbr-1)
     else
       edgeadj = eptr(baseval) - baseval
       do vertnum = baseval, baseval + velmnbr -1
         srcverttax(vertnum) = eptr(vertnum) + edgeadj
       end do
     end if

     !edgenum = eptr(velmnbr + baseval)
     !do vertnum = baseval + velmnbr, velmnbr + baseval + vnodnbr
     !  block
     !    integer(is):: degrval
     !    degrval = srcverttax(vertnum)
     !    if (degrval > degrmax) then degrmax = degrval
     !    srcverttax(vertnum) = edgenum
     !    edgenum = edgenum + degrval
     !  end block
     !end do
     !srcverttax(vertnum) = edgenum
     !allocate(srcedgetax(0:edgenbr-1))

     !do edgenum = baseval, eptr(velmnbr+baseval)-1
     !  srcedgetax(edgenum) = edgetax(edgenum) + ne
     !end do

     !do vertnum = baseval, ne+ baseval -1
     !  do edgenum = eptr(vertnum), eptr(vertnum + 1)
     !    srcedgetax(srcverttax(edgetax(edgenum) + velmnbr ) ) = vertnum
     !    srcverttax(edgetax(edgenum) + velmnbr ) = 
     !    srcverttax(edgetax(edgenum) + velmnbr ) + 1
     !  end do
     !end do

     !srcverttax(velmnbr+baseval:ne+baseval+vnodnbr-2)
     !srcverttax(velmnbr+baseval) = eptr(velmnbr+baseval)

   end subroutine metis_to_mesh


end program skotx_direkt
