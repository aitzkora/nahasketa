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
