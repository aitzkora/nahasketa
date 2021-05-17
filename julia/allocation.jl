"""
simple to solve a allocation problem by a dynamic programming method
data taken from the book (in French) 

\"Optimisation et contrôle des systèmes linéaires\" by M. Bergounioux

we want to compute a allocation of eight products for 4 stores 
maximizing the sum of utilities of each store. The time corresponds
artificially to each store and the state in the current number
of product

cost : `` \\max  \\sum_{i=1} U_i(x_i) ``

recc equation : `` y_{i+1} = y_i - x_i ``
constraints  : `` x_i \\geqslant 0 ``, ``0 \\leqslant y_i \\leqslant 8 ``
"""

"""
Utility function 
"""
U = 
[ 0 0 0 0 
  8 13 9 10
  20 20 10 20
  40 32 11 30
  48 39 44 40
  53 55 60 50
  60 64 72 60
  80 71 80 70
  100 80 80 80  ]


"""
compute the value function defined by the Bellman's equation

`` V_k(y) = \\max_x \\[ U(x) + V(f(y,x)) \\] ``
"""
function build_val_fun(U, evol)
  N = size(U, 1) - 1
  T = size(U, 2)
  V = zeros(N+1, T)
  space = [0:N;]
  V[:, T] = U[:, T]
  P = [ Set{Int64}() for x = 1:N+1, y = 1:T-1]
  for k=T-1:-1:1
    for x=space
      admis = findall(0 .<= evol.(x,space,k) .<= N)
      cout = U[space[admis].+1, k] .+ V[evol.(x,space[admis],k).+1,k+1] 
      V[x+1, k] =  maximum(cout)
      union!(P[x+1, k],findall(cout .== V[x+1,k]) .- 1)
    end
  end
  return V, P
end
