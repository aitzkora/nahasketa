function A(θ)
  return [ cos(θ) sin(θ) ; -sin(θ) cos(θ)]
end

function direct(θ,n, x0, p)
    x = x0
    @assert size(x0) == (2,)
    @assert size(p) == (n,)
        for i=1:n
            xp = A(θ) * x .+ [0; p[i]]
        x = xp
    end 
    return x
end

function cost(p)
    n = size(p, 1)
    xₙ= direct(0.1, n,[1.;0], p)
    return  xₙ[2]^2
end

using SparseArrays
function compute_grad_by_adjoint(p)
   n  = size(p, 1)
   xₙ = direct(0.1, n, [1.; 0], p)
   λ = [0 , 2. * xₙ[2]]
   ∇g = zeros(1,n) 
   for i=n:-1:1
     ∂ₚf = sparse([2], [i], 1., 2, n)
     ∇g += λ' * ∂ₚf 
     λ = A(0.1)  * λ
   end             
   return ∇g
end

function compute_diff(p, ε = 1.e-7)
    n  = size(p,1)
    ∇g = zeros(n)
    for i=1:n
        ∇g[i] = ε^(-1).*(cost(p + [ε * (i == j) for j=1:n])-cost(p))
    end
    return ∇g
end 
