program test_inverse
    use iso_c_binding 
    use m_linalg
    implicit none
    integer, parameter :: N = 84
    external :: dpotrf, dpotri
    real(c_double) :: m_inv(N,N), m(N,N), m_eye(N,N), m_fact(N,N)
   
    m_eye = eye()
    !m_inv = read_cst("inverse.dat")
    m = read_cst("matrix.dat")
    m_fact = m
    m_inv = compute_inv(m) 
    print *, maxval(abs(matmul(m_inv,m)-m_eye))

contains
     function read_cst(filename) result(mat)
       character(len=*), intent(in) :: filename
       real(c_double) :: mat(N,N)
       open(21,file=filename)
          read(21,*) mat
       close(21)
     end function read_cst
   
    function eye()
       real(c_double), target :: eye(N,N)
       real(c_double), pointer :: eye_flat(:)

       eye = 0.d0
       eye_flat(1:N*N) => eye
       eye_flat(::N+1) = 1.d0
    
    end function

end program  test_inverse
