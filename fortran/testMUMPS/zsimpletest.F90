program simple_test
    implicit none
    include 'mpif.h'
    include 'zmumps_struc.h'
    type (zmumps_struc) :: mumps_par
    integer :: ierr, i
    integer(kind=8) :: j

    call MPI_INIT(ierr)
    mumps_par % comm = MPI_COMM_WORLD
    mumps_par % job = -1
    mumps_par % sym = 0
    mumps_par % par = 1
    call zmumps(mumps_par)
    if (mumps_par % infog(1) < 0) then
        write(6,'(a,a,i6,a,i9)') " error return: ", "  mumps_par % infog(1)= ", mumps_par % infog(1), & 
                                                    "  mumps_par % infog(2)= ", mumps_par % infog(2) 
        call MPI_FINALIZE(ierr)
        stop -1
    end if
    if ( mumps_par % myid  ==  0 ) then
        read(5,*) mumps_par % n
        read(5,*) mumps_par % nnz
        allocate( mumps_par % irn ( mumps_par % nnz ) )
        allocate( mumps_par % jcn ( mumps_par % nnz ) )
        allocate( mumps_par % a( mumps_par % nnz ) )
        allocate( mumps_par % rhs ( mumps_par % n  ) )
        do j = 1, mumps_par % nnz
           read(5,*) mumps_par % irn(j),mumps_par % jcn(j), mumps_par % a(j)
        end do
        do i = 1, mumps_par % n
           read(5,*) mumps_par % rhs(i)
        end do
    end if
    mumps_par % job = 6
    call zmumps(mumps_par)
    if (mumps_par%infog(1) < 0) then
        write(6,'(a,a,i6,a,i9)') " error return: ", "  mumps_par % infog(1)= ", mumps_par % infog(1), &
                                                    "  mumps_par % infog(2)= ", mumps_par % infog(2) 
        call MPI_FINALIZE(ierr)
        stop -1
    end if
    if ( mumps_par % myid  ==  0 ) then
        write( 6, * ) ' solution is ',(mumps_par % rhs(i),i=1,mumps_par % n)
    end if
    if ( mumps_par % myid  ==  0 )then
        deallocate( mumps_par % irn )
        deallocate( mumps_par % jcn )
        deallocate( mumps_par % a   )
        deallocate( mumps_par % rhs )
    end if
    mumps_par % job = -2
    call zmumps(mumps_par)
    if (mumps_par % infog(1) < 0) then
        write(6,'(a,a,i6,a,i9)') " error return: ", "  mumps_par % infog(1)= ", mumps_par % infog(1), & 
                                                    "  mumps_par % infog(2)= ", mumps_par % infog(2) 
        call MPI_FINALIZE(ierr)
        stop -1
    end if
    call MPI_FINALIZE(ierr)
    stop 0
end program simple_test
