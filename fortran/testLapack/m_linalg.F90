module m_linalg

    public :: pretty_print, symmetrize, compute_inv

contains 

    subroutine pretty_print(a)
        real(kind=8), intent(in) :: a(:,:)
        integer  :: m,n
        character(25) :: fmt
        m = size(a, 1)
        n = size(a, 2)
        write (fmt, '(ai0ai0a)') '(', m, '(1x', n, 'f9.3/))' 
        print fmt, a 
    end subroutine pretty_print

    subroutine symmetrize(a)
        real(kind=8), intent(inout) :: a(:,:)
        integer :: m,n 
        m = size(a, 1)
        n = size(a, 2)
        do i=1,m 
        do j=i+1, n
        a(j,i) = a(i,j)
        end do
        end do
    end subroutine symmetrize 

    function compute_inv(a) result(a_inv)
        real(kind=8), intent(in) :: a(:,:)
        real(kind=8), allocatable :: a_inv(:,:) 
        integer :: n, info
        n = size(a,1)

        allocate(a_inv, mold=a)
        a_inv = a
        call dpotrf('U', n, a_inv, n, info)
        call dpotri('U', n, a_inv, n, info)
        call symmetrize(a_inv)

    end function compute_inv

end module m_linalg
