#:def dupn(k)
n1#{for j in range(1,k)}#,n${j+1}$#{endfor}#
#:enddef
#:for i in range(1,6)
  if (any([${dupn(i)}$]) > 0) then
    allocate(ctx_array%array(${dupn(i)}$)
#:endfor
