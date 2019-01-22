program sum_exp
integer :: i, n
read *, n
print *, sum(exp([(1.*i,i=1,n)]**2))
end program sum_exp
