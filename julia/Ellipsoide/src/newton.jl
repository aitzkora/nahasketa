function newton1D(f, df, x₀::T, ITER_MAX::Int64 = 100, tol::T=T(1e-12)) where {T}
  x = x₀ 
  it = 0
  while it < ITER_MAX 
    xn = x-f(x)/df(x)
    if abs(x-xn) < tol
      break
    end 
    x = xn
    it += 1
  end
  x, it
end 

"""
returns the objective and its derivative
"""
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
