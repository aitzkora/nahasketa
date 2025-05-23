program chkidx
real, dimension(-3:3) :: x
x = 0.0
x(0) = 1.0
write(*,*) 'Maximum at: ', maxloc(x)
end program chkidx
