program vandermonde
      real, dimension(:,:), allocatable :: vander
      real, dimension(:) , allocatable:: x
      integer :: n
      read *, n
      allocate(x(1:n))
      read *, x(1:n)
      allocate(vander(1:n, 1:n))
      !tab(:,:) = (/(i, i=1,10)/) ! init du tableau
      forall(i=1:n, j=1:n) vander(i,j) = x(i)**(j-1)
      print *, vander(:,:)
      deallocate(x)
      deallocate(vander)

end program vandermonde
