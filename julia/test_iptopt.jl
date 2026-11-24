using Ipopt
using LinearAlgebra
using Test
# very simple example of using iptopt
# projecting a vector on the unit circle

c=[1.; 2.];

function f(x::Vector{Float64})
  dot(x - c, x-c)/2.
end

function g!(x::Vector{Float64}, g::Vector{Float64})
  g[1] = dot(x,x)
end

function ∇f!(x::Vector{Float64}, ∇f::Vector{Float64})
  ∇f[:] = x - c;
end 

function Jg!(x::Vector{Float64},
             rows::Vector{Int32},
             cols::Vector{Int32},
             values::Union{Nothing, Vector{Float64}})
    if values == nothing
      rows[:] = ones(Int32, 2)
      cols[:] = Int32.(1:2)
    else
      values[:] = 2 .* x
    end
end

function H!(x::Vector{Float64},
  		  rows::Vector{Int32},
  		  cols::Vector{Int32},
  		  obj_factor::Float64,
  		  λ::Vector{Float64},
  		  values::Union{Nothing, Vector{Float64}})
  if values == nothing 
    idx=1
    for row = 1:2
  	for col = 1:row
  	  rows[idx] = row
  	  cols[idx] = col
  	  idx += 1
  	end
    end 
  else
    values[1] = obj_factor * 1. # 1, 1
    values[2] = 0.0             # 2, 1
    values[3] = obj_factor * 1. # 2, 2
    # constraint
    values[1] += λ[1] * 2.0
    values[3] += λ[1] * 2.0
  end
end
n = size(c, 1)
xₗ = [-10.; -10.]
xᵤ = [10.; 10.]
m = 1
gₗ = [1.0]
gᵤ = [1.0]
prob = Ipopt.CreateIpoptProblem(
      n, xₗ, xᵤ, m,gₗ, gᵤ, 2, n*(n+1)÷2,
      f, g!, ∇f!, Jg!, H!)
prob.x = [3., 3.] 
solvestat = Ipopt.IpoptSolve(prob)

@test c./norm(c) ≈ prob.x atol=1e-10
