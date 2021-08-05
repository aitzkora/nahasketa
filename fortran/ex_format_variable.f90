program ex_format
  real, allocatable, dimension(:,:) :: a
  integer :: i, j, n = 3
  logical, allocatable, dimension(:,:) :: bool
  character(len=25) variable_format
  a = reshape([(1.*i, i=1,9)], [3, 3])
  write (variable_format, '(ai0ai0a)') "(",n , "(", n , "e10.5/))"
  print variable_format ,a
end program  ex_format
