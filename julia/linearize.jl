function linearize(n1,n2)
  func=zeros(Int64,2, n1*n2)
  cnt=0
  for i=1:n1
    for j=1:n2
      cnt+=1
      func[1, cnt] = i
      func[2, cnt] = j
    end
  end
  return func
end

function ⊗(u, v)
  nu = size(u,1)
  nv = size(v,1)
  return [reshape(repeat(u, inner=nv),1,nu*nv)
          reshape(repeat(v, outer=nu),1,nu*nv)]
end
