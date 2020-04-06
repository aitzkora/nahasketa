program test_do

    use iso_fortran_env
    !use omp_lib, only: omp_get_wtime

    integer, parameter :: n = 1000000, m = 10000
    real,  allocatable :: q(:)

    integer :: i
    real    :: x, t0, t1

    allocate(q(n))

    !t0 = omp_get_wtime()
    call cpu_time(t_0)
    do i = 1, n
        q(i) = i
        do j = 1, m
            q(i) = 0.5 * (q(i) + i / q(i))
        end do
    end do

    call cpu_time( t1 )
    print *, t1 - t0

    call cpu_time( t0 )
    do concurrent (i = 1:n)
        q(i) = i
        do j = 1, m
            q(i) = 0.5 * (q(i) + i / q(i))
        end do
    end do
    call cpu_time( t1 )
    print *, t1 - t0

end program test_do
