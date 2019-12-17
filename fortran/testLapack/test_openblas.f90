program test_open 
    use iso_c_binding 
    integer, parameter :: N = 84
    real(c_double) :: m_inv(N,N), m(N,N), m_check(N,N), m_eye(N,N)
   
    m_eye = eye()
    m = read_cst("inverse.dat")
    m_inv = read_cst("matrix.dat")
    m_check = matmul(m_inv,m)
    !print '(4(4(1x1f9.7)/))', m_eye
    print *, maxval(abs(m_check-m_eye))

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

end program  test_open
