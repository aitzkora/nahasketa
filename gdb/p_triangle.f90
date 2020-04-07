program print_triangle
    type point
        integer ::x, y, index
    end type point

    type triangle
        type(point) :: t(3)
    end type triangle

    integer :: global_index
    type(point) :: z
    type(triangle) :: t1
    z = point(2,2, 3)
    t1 = init_triangle( [0, 0, 0, 1, 1, 0] , [1, 2, 3])
    print *, "coucou"

contains

    pure function init_triangle(values, indexes) result(t)
        type(triangle) :: t
        integer, intent(in) :: values(6), indexes(3)
        t%t(1) = point(values(1), values(2), indexes(1))
        t%t(2) = point(values(3), values(4), indexes(2))
        t%t(3) = point(values(5), values(6), indexes(3))
    end function init_triangle

end program
