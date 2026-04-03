program test_scotchElem
  use iso_c_binding
  implicit none
  
  integer, parameter :: SCOTCH_Num = c_int32_t
  interface
    subroutine free_c(ptr) bind(c, name='free')
      use, intrinsic :: iso_c_binding, only: c_ptr
      type(c_ptr), value, intent(in) :: ptr
    end subroutine free_c

    subroutine exit_c(val) bind(c, name='exit')
      use, intrinsic :: iso_c_binding, only: c_int
      integer(c_int), value, intent(in) :: val
    end subroutine exit_c
  
    function SCOTCH_meshBuildElem_c(meshptr, velmbas, vnodbas, velmnbr, vnodnbr, &
          verttab, vendtab, velotab, vnlotab, vlbltab, edgenbr, edgetab) result(info) &
          bind(C, name="SCOTCH_meshBuildElem")
          import SCOTCH_Num, c_ptr
        type(c_ptr),         intent(inout) :: meshptr
        integer(SCOTCH_Num), value         :: velmbas
        integer(SCOTCH_Num), value         :: vnodbas
        integer(SCOTCH_Num), value         :: velmnbr
        integer(SCOTCH_Num), value         :: vnodnbr
        type(c_ptr),         value         :: verttab
        type(c_ptr),         value         :: vendtab
        type(c_ptr),         value         :: velotab
        type(c_ptr),         value         :: vnlotab
        type(c_ptr),         value         :: vlbltab
        integer(SCOTCH_Num), value         :: edgenbr
        type(c_ptr),         value         :: edgetab
        integer(SCOTCH_Num) :: info
      end function SCOTCH_meshBuildElem_c

      function SCOTCH_meshAlloc_c() result(meshptr) bind(C, name="SCOTCH_meshAlloc")
        import :: c_ptr
        type(c_ptr) :: meshptr
      end function SCOTCH_meshAlloc_c

      subroutine SCOTCH_meshExit_c(meshdat) bind(C, name="SCOTCH_meshExit")
        import :: c_ptr
        type(c_ptr), intent(inout) :: meshdat
      end subroutine SCOTCH_meshExit_c
  
  end interface


  integer     ::                    ok
  type(c_ptr) ::                     meshptr
  integer(SCOTCH_NUM), parameter ::  vnodbas      = 0
  integer(SCOTCH_NUM), parameter ::  velmnbr      = 6
  integer(SCOTCH_NUM), parameter ::  vnodnbr      = 7
  integer(SCOTCH_NUM)            ::  edgenbr
  integer(SCOTCH_NUM), target            ::  verttab(7)   = [ 0, 3, 6, 9, 12, 15, 18 ]
  integer(SCOTCH_NUM), target            ::  edgetab(18)  = [ 0, 1, 2, 0, 1, 5, 1, 5, 4, 1, 4, 6, 1, 6, 3, 1, 3, 2 ]

  edgetab (:)  = edgetab (:)  + vnodbas
  verttab (:)  = verttab (:)  + vnodbas

  edgenbr = verttab(vnodnbr) - vnodbas

  meshptr = SCOTCH_meshAlloc_c()
  !if( meshptr == c_null_ptr) then
  !  print *, "ERROR: can't alloc a mesh"
  !  call exit_c (1)
  !end if

  ok = Scotch_meshBuildElem_c(meshptr, vnodbas, vnodbas, velmnbr, vnodnbr, c_loc(verttab), c_loc(verttab(vnodbas+1)), &
       c_null_ptr, c_null_ptr, c_null_ptr, edgenbr, c_loc(edgetab))
  if (ok /= 0) then
    print *, "error in Scotch_meshBuilElem"
    call exit_c (1)
  end if

  call SCOTCH_meshExit_c(meshptr)

end program test_scotchElem
