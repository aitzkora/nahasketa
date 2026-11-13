using IntervalRootFinding
using IntervalArithmetic.Symbols 

function proj_ellipsoide_root(a::Vector{Float64}, x::Vector{Float64})
    g = μ-> sum(a.^2 .* x.^2 ./ (a.^2 .+ μ).^2) - 1
    r1 = roots(g, 0..1000)[1].region.bareinterval
    μ₀ = 0.5*(r1.lo + r1.hi)
    x₀ = a.^2 .* x ./ (a.^2 .+μ₀)
    return x₀, μ₀
end

