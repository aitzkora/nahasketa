program copy
 integer, parameter :: N = 1000
 integer, allocatable :: a_1d(:) , a_2d(:,:) , i
 a_2d = reshape([(i,i=1,N*N)],[N,N])
 a_1d = pack(a_2d, .true.)
 print *, sum(a_1d)
end program copy
