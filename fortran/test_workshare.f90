program test_workshare
    implicit none
    real(kind=8), allocatable, dimension(:) :: a,b,c
    character(len=80) :: param, cmd
    integer :: i, n, narg

    narg = command_argument_count()
    call get_command_argument( 0, cmd )
    if (narg < 1) then
        print *, "usage : "//trim(cmd) // " n"
        stop
    end if

    call get_command_argument( 1,param )
    read(param,*) n

    allocate(a(n))
    a = [(i,i=1,n)]
    allocate( b, source = a )
    allocate( c, mold = a )

    !$omp parallel workshare
    c = a + b
    !$omp end parallel workshare

    print *, sum(c)

end program test_workshare
