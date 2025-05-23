using Test
nCov = 5
selVars = [Int64[] for _=1:2^nCov]
for i=1:2^nCov
    selVars[i] = findall(digits(i-1, base=2, pad=nCov).!=0)
end

n2p(n, x) = (1:n)[digits(x-1, base=2, pad=n).!=0]
n2b(n, x) = digits(x-1, base=2, pad=n).!=0

p2n(p) = sum(2 .^ (p .- 1)).+1

is_subset(n, a, b) = n2b(n, a) .| n2b(n, b) ==n2b(n, b)

@test is_subset(5,13,13)


function bf_generate_subsets(n, a)
  l = []
  for i=1:2^n
    if(is_subset(n, i, a))
      push!(l,n2p(n,i))
    end
  end 
  return l
end 

function trick_gen_subsets(n, a)
  l = []
  a_ones = n2b(n,a)
  ind_ones = findall(a_ones .!=0)
  m = length(ind_ones) 
  for i=1:2^m
     push!(l, (1:n)[[(w in ind_ones[n2b(m, i)]) for w=1:n]])
  end
  l
end

function trick_gen_ind_subsets(n, a)
  l = []  
  a_ones = n2b(n,a)
  ind_ones = findall(a_ones .!=0)
  m = length(ind_ones) 
  for i=1:2^m
     push!(l, p2n((1:n)[[(w in ind_ones[n2b(m, i)]) for w=1:n]]))
  end
  return l
end


