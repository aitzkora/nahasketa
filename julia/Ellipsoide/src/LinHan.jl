"""
Lin-Han algorithm :
slow (linear) algorithm to project `a` on 𝓔 = { x ∈ ℝⁿ | <Ax,x> ⩽ α } 
function lin_han(A, α, a, x₀, ζ; tol, ITER_MAX, verbose) 
"""
function lin_han(A::AbstractMatrix{T}, α::T, a::Vector{T}, x₀::Vector{T}, ζ::T = T(0.01); 
                tol::T = T(1e-6), ITER_MAX::Int64=2000,  verbose::Bool=false) where {T}
 xₖ = x₀
 gₐ = A * a 
 q_a_α  = a' * gₐ - α
 i = 1
 while i < ITER_MAX
   vₖ = a - xₖ 
   uₖ = A * xₖ
   if (1. - dot(uₖ, vₖ)/ norm(uₖ) /norm(vₖ) <= tol)
     return xₖ, i
   end
   cₖ = xₖ - ζ * uₖ
   wₖ = a - cₖ
   num = gₐ' * wₖ
   denom = dot(wₖ, A, wₖ)
   tmp = num / denom
   ηₖ = -tmp - √(tmp*tmp-q_a_α/denom)
   xₖ = a .+ ηₖ .* wₖ
   i += 1
   if (verbose)
     println("$i ->  $(norm(vₖ))")
   end
 end   
 if (i == ITER_MAX) 
     println("WARNING : Lin-Han algorithm does not converge!")
 end 
 return xₖ, i
end 
