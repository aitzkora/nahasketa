include("IntegrationFormula.jl")
"""
create the B_k matrix which corresponds to the linear map  from the 
reference element T = \{ (x,y,z) : x,y,z ≥ 0 x+y+z = 1 \} to the
current triangle 
Input :
------
x : a 3 x m matrix containing all the points of the current element
Output :
-------
B_k = [ p_m - p_1, \cdot, p_2 ... p_1]
"""
function mapRefToLocal(x::Array{Float64,2})
    @assert(size(x, 1) == 3)
    return x[:,2:end].-x[:,1:1] # or cumsum(diff(x,2),2)
end

using Base.Test
a = reshape([ gcd(i,j) + 0. for i=1:4 for j=1:3], 3,4)
@test mapRefToLocal(a[:,1:2]) ≈ [0, 1, 0] atol=1e-12
@test mapRefToLocal(a[:,1:3]) == [0 0; 1 0; 0 2]
@test mapRefToLocal(a[:,1:4]) == [0 0 0; 1 0 1; 0 2 0]

"""
jacobian(x)

compute the jacobian of the current element

"""
function jacobian(x::Array{Float64,2})
    m = mapRefToLocal(x)
    n = size(m, 2)
    @assert (n in 1:3)
    if (n == 1)
        return norm(m)
    elseif (n == 2)
        return norm(cross(m[:,1], m[:, 2]))
    elseif (n == 3)
        return det(m)
    end
end

a = reshape([ gcd(i,j) + 0. for i=1:4 for j=1:3], 3,4)
@test jacobian(a[:,1:2]) == 1
@test jacobian(a[:,1:3]) == 2
@test jacobian(a[:,1:4]) == 0


include("BasisFunction.jl")
function computeφAndDφOnGaußPoints(fun::BasisFunction, form::IntegrationFormula)
m = size(fun.φ, 1)
n = size(form.points, 1)
M = Float64[fun.φ[i](form.points[k]) for i=1:m, k=1:n]
N = Float64[fun.Dφ[i,j](form.points[k]) for i=1:m, j=1:m , k=1:n]
return M,N
end


"""
cartesianProduct(x, y)

  Cartesian product of two sets describing by vectors

# Example

julia> cartesianProduct([2,4],[1,2,3])
([2, 2, 2, 4, 4, 4], [1, 2, 3, 1, 2, 3])

"""
function cartesianProduct(x,y)
    return repeat(x,inner=size(y,1)),repeat(y,outer=size(x,1))
end


include("Mesh.jl")
function stiffnesAndMassMatrix(mesh::Mesh, order::Int64, fun::BasisFunction)
    m = size(mesh.cells, 1)
    n = size(mesh.points, 1)
    K = spzeros(n, n)
    M = spzeros(n, n)
    # dim cst
    dim = size(mesh.points[1], 2)
    form = IntegrationFormula(dim, order)
    φ, Dφ = computeφAndDφOnGaußPoints(fun, form)
    for el in 1:m
        indices = mesh.cells[el]
        pts   = mesh.points[indices, :]'
        bK    = mapRefToLocal(pts)
        jK    = jacobian(pts)
        mElem = φ * Diagonal(jk.*form.weights)*φ'
        M += sparse(cartesianProduct(indices, indices)...,mElem[:], n,n)
    end
end
