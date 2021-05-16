U = 
[ 0 0 0 0 
  8 13 9 10
  20 20 10 20
  20 32 11 30
  48 39 44 40
  53 55 60 50
  60 64 72 60
  80 71 80 70
  100 80 80 80  ]

function build_val_fun(U, evol)
  N = size(U, 1) - 1
  T = size(U, 2)
  V = zeros(N+1, T)
  space = [0:N;]
  V[:, T] = U[:, T]
  for k=T-1:-1:1
    for x=space
      admis=findall(0 .<= evol.(x,space,k) .<= 8 )
      V[x+1, k] =  maximum(U[space[admis].+1, k] .+ V[evol.(x,space[admis],k).+1,k+1])
    end
  end
  return V
end




