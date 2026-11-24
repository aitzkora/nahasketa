using Ipopt
using LinearAlgebra
using Test
# very simple example of using iptopt
# projecting a vector on the unit circle

c=[1:10;]

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
      rows[:] = ones(Int32, n)
      cols[:] = Int32.(1:n)
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
  n = size(x,1)
  if values == nothing 
    idx=1
    for row = 1:n
      for col = 1:row
        rows[idx] = row
        cols[idx] = col
        idx += 1
      end
    end 
  else
    idx = 1
    for i=1:n
      for j=1:i
        if i==j
          values[idx] = obj_factor * 1. # diag
          # constraint
          values[idx] += λ[1] * 2.0
        else 
          values[idx] = 0.0   
        end 
        idx+=1
      end
    end
  end
end
n = size(c, 1)
xₗ = -10 * ones(n)
xᵤ = 10 * ones(n)
m = 1
gₗ = [1.0]
gᵤ = [1.0]
prob = Ipopt.CreateIpoptProblem(
      n, xₗ, xᵤ, m,gₗ, gᵤ, n, n*(n+1)÷2,
      f, g!, ∇f!, Jg!, H!)
prob.x = 3. .*ones(n)
solvestat = Ipopt.IpoptSolve(prob)

@test c./norm(c) ≈ prob.x atol=1e-10
