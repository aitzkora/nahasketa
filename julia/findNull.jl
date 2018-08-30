using Base.Test
"""
cartesianProduct(x, y)

  Cartesian product of two sets describing by vectors

# Examples

julia> cartesianProduct(["a","b"],[1,2,3])
[("a",1)  ("a", 2) ("a", 3) ("b", 1) ("b", 2) ("b", 3)]
6-element Array{Tuple{String,Int64},1}:
("a", 1)
("a", 2)
("a", 3)
("b", 1)
("b", 2)
("b", 3)

"""
function cartesianProduct(x,y)
    return collect(zip(repeat(x,inner=size(y,1)),repeat(y,outer=size(x,1))))
end
@test cartesianProduct(["a","b"],[1,2,3]) == [("a",1), ("a", 2), ("a", 3), ("b", 1), ("b", 2), ("b", 3)]

"""
computes the n-th cartesian product of a set with itself , i.e.  E \times \cdots \times E  = E^n

"""
function cartesianProductIterate(set, n::Int)
    x = cartesianProduct(set, set)
    for i =2:n-1
        x = cartesianProduct(x, set)
        x = map((z->(z[1][1:end]...,z[2])),x)
    end
    return x
end

"""
search for all matrices in with coefs in \mathbb{Z} of module  \leqslant n 
such that A^2 = 0
"""

function findNull(n)
    solutions = []
    coefs = cartesianProductIterate(-n:n, 9)
    n = length(coefs)
    for z = 1:n
        a = reshape([coefs[z]...], 3,3)
        if norm(a*a) < 1e-12
            push!(solutions, a)
        end
    end
    return solutions
end


