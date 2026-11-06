module Ellipsoide

using LinearAlgebra
using Optim
using Infiltrator
using Revise
export newton1D, proj_ellipsoide_diag, proj_ellipsoide_root, lin_han_gen, ADMM, getProblem, getFuns, expe, ADMM_diag

include("misc.jl")

function getFuns(a::Vector{T}, x::Vector{T}) where {T}
  f = μ -> sum(a.^2 .* x.^2 ./ (a.^2 .+ μ).^2) - 1.
  df = μ -> -2. * sum(a.^2 .* x.^2 ./(a.^2 .+μ).^3)
  return f, df
end

function proj_ellipsoide_diag(a::Vector{T}, x::Vector{T}) where {T}
  f, df = getFuns(a, x)
  μ₀, it = newton1D(f,df, 0.)
  x₀ = a.^2 .* x ./ (a.^2 .+ μ₀)
  return x₀, μ₀, it
end

using IntervalRootFinding
using IntervalArithmetic.Symbols 
function proj_ellipsoide_root(a::Vector{Float64}, x::Vector{Float64})
    g = μ-> sum(a.^2 .* x.^2 ./ (a.^2 .+ μ).^2) - 1
    r1 = roots(g, 0..1000)[1].region.bareinterval
    μ₀ = 0.5*(r1.lo + r1.hi)
    x₀ = a.^2 .* x ./ (a.^2 .+μ₀)
    return x₀, μ₀
end


function lin_han_gen(A::Matrix{Float64}, α::Float64, a::Vector{Float64}, x₀::Vector{Float64}; tol::Float64 = 1e-6, ITER_MAX::Int32=Int32(2000), ζ::Float64 = 0.01)
 xₖ = x₀
 gₐ = A * a 
 q_a_α  = a' * gₐ - α
 i = 1
 while i < ITER_MAX
   vₖ = a - xₖ 
   uₖ = A * xₖ
   if (1. - uₖ'* (a .- xₖ) / norm(uₖ) /norm(vₖ) <= tol)
     return xₖ
   end
   γₖ = ζ
   cₖ = xₖ - γₖ * uₖ
   wₖ = a - cₖ
   num = gₐ' * wₖ
   denom = wₖ' * A * wₖ
   tmp = num / denom
   ηₖ = -tmp - √(tmp*tmp-q_a_α / denom)
   xₖ = a .+ ηₖ .* wₖ
   i += 1
   print("$i ->  $(norm(vₖ)) \n")
 end   
 if (i == ITER_MAX) 
     print("WARNING : algorithms does not converge!")
 end 
end 


function ADMM(A::AbstractMatrix{T}, b::Vector{T}, α::T, a::Vector{T}, y₀::Vector{T}, λ₀::Vector{T}, θ::T; tol::T=T(1e-6), ITER_MAX::Int64=1000) where {T}
   y = y₀
   λ = λ₀
   B = sqrt(A)
   bm = -(B')\b
   r = √(α+dot(bm,bm))
   Am = inv(I+θ*B'*B)
   k = 0
   flag = true
   res = copy(y)
   while k < ITER_MAX && flag
     u = a + B'*λ + θ*B'*(y+bm)
     x = Am * u
     w = B * x - λ./θ - bm
     nr = norm(w)
     if nr ≤ r 
       y = w
     else
       y = r/nr .* w 
     end
     λ -= θ*(B*x-y-bm)
     Rx = x - a - B'*λ
     # compute Py[y-λ] 
     if dot(y-λ,y-λ) ≤ r*r
        Py = y-λ
     else
       Py = (y-λ)/norm(y-λ) * r
     end
     Ry =  y - Py
     Rλ = B*x-y-bm
     residu = Rx'*Rx + Ry'*Ry + Rλ'*Rλ 
     flag = residu > tol*tol
     #println("$k -> $residu")
     k += 1
     res = x
   end
   if (k> ITER_MAX)
     println("nb max d'iter atteint -> pas de conv")
   end 
   return res, k
 end

function ADMM_diag(d::Vector{T}, b::Vector{T}, α::T, a::Vector{T}, y₀::Vector{T}, λ₀::Vector{T}, θ::T; tol::T=T(1e-6), ITER_MAX::Int64=1000) where {T}
  y = y₀
  λ = λ₀
  bd = sqrt.(d)
  bm = -b ./ bd
  r = √(α+dot(bm,bm))
  am = 1 ./ (1 .+ θ * bd.^2)
  k = 0
  flag = true
  res = copy(y)
  while k < ITER_MAX && flag
    u = a + bd .* λ + θ * bd .* (y+bm)
    x = am .* u
    w = bd .* x - λ./θ - bm
    nr = norm(w)
    if nr ≤ r 
      y = w
    else
      y = r/nr .* w 
    end
    λ -= θ*(bd.*x-y-bm)
    Rx = x - a - bd.*λ
    # compute Py[y-λ] 
    if dot(y-λ,y-λ) ≤ r*r
      Py = y-λ
    else
      Py = (y-λ)/norm(y-λ) * r
    end
    Ry =  y - Py
    Rλ = bd.*x-y-bm
    residu = Rx'*Rx + Ry'*Ry + Rλ'*Rλ 
    flag = residu > tol*tol
    #println("$k -> $residu")
    k += 1
    res = x
  end
  if (k> ITER_MAX)
    println("nb max d'iter atteint -> pas de conv")
  end 
  return res, k
end

function getProblem(N, ncond, ω, v)
  b = exp10.(collect(0:N-1) .* ncond / (N-1))
  at = b .^ (-ω)
  xs = at ./ √dot(b .* at, at)
  u = xs + (v.^2 - dot(xs,xs))/ (1+√(1+dot(b.*xs, b.*xs)*(v.^2 - dot(xs,xs)))) * (b.*xs)
  a = 1. ./ sqrt.(b)
  return b, u, xs, a
end


function expe()
  N = 10
  ncond = [3, 4, 5]
  omega = [1/8., 1/4., 1/2.]
  𝒱 = [2, 5, 10, 50] 
  its = zeros(Int32, length(ncond), length(omega), length(𝒱))
  tps = zeros(Float32, length(ncond), length(omega), length(𝒱))
  for (i, nc) ∈ enumerate(ncond)
    for (j, ω) ∈ enumerate(omega)
      for (k,v) ∈ enumerate(𝒱)
        println("nc = $nc, ω = $ω , v=$v")
        b, u, xs, a = getProblem(N, nc, ω, v)
        xo, μo, it = proj_ellipsoide_diag(a, u)
        @assert xo ≈ xs
        its[i,j,k] = it
        tps[i,j,k] = @elapsed proj_ellipsoide_diag(a, u)
      end
    end
  end
  return its, tps
end

end # module Ellipsoide
