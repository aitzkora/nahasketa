program skotx_direkt
  use iso_c_binding
  implicit none

  include 'scotchf.h'
  integer, parameter :: is = SCOTCH_NUMSIZE

  real(c_double)             :: meshdat(scotch_meshdim)
  real(c_double)             :: grafdat(scotch_graphdim)
  type(c_ptr)                :: xadj
  type(c_ptr)                :: adjncy

  integer(is)            :: edgenbr = 18
  integer(is), parameter ::   baseval      = 1
  integer(is), parameter ::   ne           = 6
  integer(is), parameter ::   nn           = 7
  integer(is) ::              eptr(7)      = [ 0, 3, 6, 9, 12, 15, 18 ]
  integer(is) ::              eind(18)     = [ 0, 1, 2, 0, 1, 5, 1, 5, 4, 1, 4, 6, 1, 6, 3, 1, 3, 2 ]
  integer(is) ::              ierr
  integer(is) :: grafbaseval 
  integer(is) :: grafvertnbr 
  type(c_ptr) :: grafverttab
  type(c_ptr) :: grafvendtab 
  integer(is) :: grafedgenbr 
  type(c_ptr) :: grafedgetab
  type(c_ptr) :: grafedlotab
  integer(is) :: vertnum, vertindex

  interface
    function graph_data(grafptr,baseval,vertnbr,verttab,vendtab,velotab,vlbltab,edgenbr,edgetab,endlotab)  &
      bind(C,name="SCOTCH_graphData")
      import c_ptr, is, c_double, scotch_graphdim
      real(c_double) :: grafptr(scotch_graphdim)
      type(c_ptr) :: verttab, vendtab, velotab, vlbltab
      type(c_ptr) :: edgetab, endlotab
      integer(is) :: baseval, vertnbr, edgenbr
      integer(is) :: graph_data
    end function graph_data !standard C library qsort
  end interface
  

  ! mesh fortran datatype 
  type :: mesh_scotch 
     integer(is)              :: velmbas
     integer(is)              :: vnodbas
     integer(is)              :: velmnbr
     integer(is)              :: vnodnbr
     integer(is), allocatable :: verttab(:)
     integer(is)              :: edgenbr
     integer(is), allocatable :: edgetab(:)
  end type mesh_scotch
 
  integer(is), pointer :: verttab_f(:), edgetab_f(:)
 
  type(mesh_scotch) :: mesh

  eind (:)     = eind (:)     + baseval
  eptr (:)     = eptr (:)     + baseval

  call metis_to_mesh(mesh, baseval, nn, ne, eptr, edgenbr, eind)

  call scotchfmeshbuild(meshdat, mesh%velmbas, mesh%vnodbas,               &
                                 mesh%velmnbr, mesh%vnodnbr,               &
                                 mesh%verttab, mesh%verttab(baseval+1),    &
                                 mesh%verttab, mesh%verttab, mesh%verttab, &
                                 mesh%edgenbr, mesh%edgetab, ierr)

  if (ierr /= 0) stop "could not build mesh"

  call scotchfmeshgraphdual (meshdat, grafdat, 2, ierr)

  if (ierr /= 0 ) stop "could not build the dual graph"
  
  ierr = graph_data (grafdat, grafbaseval, grafvertnbr, grafverttab, grafvendtab, & 
                     c_null_ptr, c_null_ptr, grafedgenbr, &
                     grafedgetab, grafedlotab )

   print '(a,i0)', "baseval : ", grafbaseval
   print '(a,i0)', "vertnbr : ", grafvertnbr
   print '(a,i0)', "edgenbr : ", grafedgenbr


   call c_f_pointer(grafverttab, verttab_f, shape=[grafvertnbr+1])
   call c_f_pointer(grafedgetab, edgetab_f, shape=[grafedgenbr])


  do vertnum=grafbaseval, grafvertnbr+grafbaseval-1
    block
       integer :: nb 
       character(len=25) :: variable_format
       nb = verttab_f(vertnum+1)-verttab_f(vertnum)
       write (variable_format, '(a,i0,a)') "(i0,a,",nb, "(i0,1x))"
       print variable_format, vertnum, " : ", edgetab_f(verttab_f(vertnum):verttab_f(vertnum+1)-1) 
    end block
  end do


contains 

   subroutine metis_to_mesh(mesh, baseval, vnodnbr, velmnbr, verttab, edgenb, edgetab)
     type(mesh_scotch), intent(out) :: mesh
     integer(is), intent(in) :: baseval
     integer(is), intent(in) :: vnodnbr , velmnbr
     integer(is), intent(in) :: verttab(baseval:velmnbr+baseval) ! beware : velmnbr+1
     integer(is), intent(in) :: edgenb
     integer(is), intent(in) :: edgetab(baseval:edgenb+baseval)

     integer(is) :: vertnum, degrmax, edgeadj
     integer(is), allocatable :: srcverttax(:), srcedgetax(:), tmp(:)
     integer(is) :: edgechk, edgenum, velmnnd

     velmnnd = velmnbr + baseval

     allocate(srcverttax(baseval:vnodnbr+velmnbr+baseval))

     edgechk = verttab(velmnbr+baseval)
#ifndef NDEBUG
     if (edgechk-baseval /= edgenb) then
        stop "bad bounds for edgetab"
     endif
#endif
     srcverttax(velmnbr:) = 0
     degrmax = 0
     edgenbr = 0
     ! we want to compute the edgenbr
     ! loop on elems
     do vertnum= baseval, baseval+velmnbr-1
       block
         integer(is) :: edgennd, degrval, ind
         edgenum = verttab(vertnum)
         edgennd = verttab(vertnum+1)
         degrval = edgennd - edgenum
         if (degrval > degrmax) then 
           degrmax = degrval
         end if
         edgenbr = edgenbr + degrval
         EDGE : do 
           if (edgenum == edgennd) exit
           ind = velmnbr + edgetab(edgenum) 
           srcverttax(ind) = srcverttax(ind) + 1
           edgenum = edgenum  + 1
         end do EDGE
       end block
     end do

#ifndef NDEBUG
     if (edgenbr /= edgechk-baseval) stop "error in computation of edgenbr"
#endif
     edgenbr = edgenbr * 2

     if (verttab(baseval) == baseval) then
       srcverttax(baseval:baseval+velmnbr-1) = verttab(baseval:baseval+velmnbr-1)
     else
       edgeadj = verttab(baseval) - baseval
       do vertnum = baseval, baseval + velmnbr -1
         srcverttax(vertnum) = verttab(vertnum) + edgeadj
       end do
     end if

     edgenum = verttab(velmnnd)
     do vertnum = velmnnd, velmnnd + vnodnbr - 1
       block
         integer(is) :: degrval
         degrval = srcverttax(vertnum)
         if (degrval > degrmax) degrmax = degrval
         srcverttax(vertnum) = edgenum
         edgenum = edgenum + degrval
       end block
     end do
     srcverttax(vertnum) = edgenum
     
     allocate(srcedgetax(baseval:baseval+edgenbr-1))


     do edgenum = baseval, verttab(velmnnd)-1
       srcedgetax(edgenum) = edgetab(edgenum) + velmnbr
     end do

     do vertnum = baseval, velmnnd -1
       do edgenum = verttab(vertnum), verttab(vertnum + 1)-1
         srcedgetax(srcverttax(edgetab(edgenum) + velmnbr ) ) = vertnum
         srcverttax(edgetab(edgenum) + velmnbr ) = &
         srcverttax(edgetab(edgenum) + velmnbr ) + 1
       end do
     end do

     tmp = srcverttax(velmnnd:velmnnd+vnodnbr-2)
     srcverttax(velmnnd+1:velmnnd+1+vnodnbr-2) = tmp(:)
     deallocate (tmp)

     srcverttax(velmnnd) = verttab(velmnnd)

     mesh%velmbas = baseval
     mesh%vnodbas = velmnnd
     mesh%vnodnbr = vnodnbr
     mesh%velmnbr = velmnbr
     call move_alloc (from=srcedgetax, to=mesh%edgetab)
     call move_alloc (from=srcverttax, to=mesh%verttab)
     mesh%edgenbr = edgenbr
   end subroutine metis_to_mesh


end program skotx_direkt
