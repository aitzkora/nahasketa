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
    k += 1
    println("$k -> $residu")
    res = x
  end
  if (k> ITER_MAX)
    println("nb max d'iter atteint -> pas de conv")
  end 
  return res, k
end
"""
ADMM_S_diag(d, b, α, a, y₀, λ₀, θ₀, ν, μ; tol, ITER_MAX) 
"""
function ADMM_S_diag(d::Vector{T}, b::Vector{T}, α::T, a::Vector{T}, y₀::Vector{T}, λ₀::Vector{T}, θ₀::T, μ::T = T(10.), τ::T=T(2.) ; tol::T=T(1e-6), ITER_MAX::Int64=2000) where {T}
  θ = θ₀
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
    # adapt θ
    if dot(Rx, Rx) > μ * dot(Rλ, Rλ)
      θ *= (1. + τ)
    elseif dot(Rλ, Rλ) > μ * dot(Rx, Rx)
      θ /= (1. + τ)
    end
    flag = residu > tol*tol
    println("$k -> $residu")
    k += 1
    res = x
  end
  if (k> ITER_MAX)
    println("nb max d'iter atteint -> pas de conv")
  end 
  return res, k
end
