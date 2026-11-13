function getProblem(N::Int, ncond::Number, ω::Number, v::Number)
  b = exp10.(collect(0:N-1) .* ncond / (N-1))
  at = b .^ (-ω)
  xs = at ./ √dot(b .* at, at)
  u = xs + (v.^2 - dot(xs,xs))/ (1+√(1+dot(b.*xs, b.*xs)*(v.^2 - dot(xs,xs)))) * (b.*xs)
  a = 1. ./ sqrt.(b)
  return b, u, xs, a
end

"""
provides parameters for 𝓔 = { x ∈ ℝⁿ | Σᵢ₌₁ i² xᵢ² = 385 } 
b, α, u, xs, x₀, a =  getSimpleProblem(N)
"""
function getSimpleProblem(N)
  α  = 385.
  u  = N.*(1:N).^2 .+ 1.
  xs = ones(N)
  b = (Float64.(1:N)).^2
  qu = u' * (b.* u)
  x₀ = √(α/qu) .* u
  a = 1. ./ (1:N)
  return b, α, u, xs, x₀, a
end

function expe()
  N = 10
  ncond = [3, 4, 5]
  omega = [0., 1/8., 1/4., 1/2.]
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
