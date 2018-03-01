type BasisFunction
    φ::Array{Function}
    Dφ::Array{Function,2}
    BasisFunction(ψ::Array{Function}, Dψ::Array{Function,2}) =
    begin
        @assert size(ψ,1) == size(Dψ,1)
        @assert size(Dψ,2) + 1 == size(Dψ,1)
        new(ψ,Dψ)
    end
end

function P1Basis(x::Int64)
   if     (x == 1)
       return BasisFunction([x->1-x[1], x->x[1]], reshape([[x->-1];[x->1]],2,1))
   elseif (x == 2)
       return BasisFunction([x->1-x[1]-x[2], x->x[1], x->x[2]], [[x->-1 x->-1]; [x->1 x->0];[x->0 x->1]])
   elseif (x == 3)
       return BasisFunction([x->1-sum(x[1:3]), x->x[1], x->x[2], x->x[3]],
                             [[x->-1 x->-1 x->-1];[x->1 x->0 x->0];[x->0 x->1 x->0]; [x->0 x->0 x->1]])
   else
       error("P1Basis: calling P1Basis(n) with n not in {1,2,3}")
   end
end

using Base.Test
for n=1:3
     basis = P1Basis(n)
     λ = rand(n+1)
     λ = λ/sum(λ)
     vertices = [zeros(n,1) eye(n)]
     x = vertices * λ
     @test sum([basis.φ[j](x) for j in 1:(n+1)]) ≈ 1. atol=1e-12
     @test norm(sum(reshape([basis.Dφ[i,j](x) for i=1:(n+1) for j=1:n],n,n+1),2))==0
end
