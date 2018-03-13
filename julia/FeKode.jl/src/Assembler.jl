"""
create the B_k matrix which corresponds to the linear map  from the 
reference element ``T = \{ (x,y,z) : x,y,z ≥ 0 x+y+z = 1 \}` to the
current triangle

# Arguments :
* x : a 3 x m matrix containing all the points of the current element
# Returns : 
``B_k = [ p_m - p_1, \cdot, p_2 ... p_1]``
"""
function mapRefToLocal(x::Array{Float64,2})
    @assert(size(x, 1) == 3)
    return x[:,2:end].-x[:,1:1] # or cumsum(diff(x,2),2)
end

"""
jacobian(x)

compute the jacobian of the current element, i.e. the elementary surface
* 1-D : ``\|B_k\| ``
* 2-D : ``\|B_k^1 \wedge B_k^2 \|``
* 3-D : ``|\det B_k|``
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
        return abs(det(m))
    end
end

function computeφAndDφOnGaußPoints(fun::BasisFunction, form::IntegrationFormula)
m, n = size(fun.Dφ)
p = size(form.points, 2) # beware that points are stored vertically
M = Float64[fun.φ[i](form.points[:, k]) for i=1:m, k=1:p]
N = Float64[fun.Dφ[i,j](form.points[:, k]) for i=1:m, j=1:n, k=1:p]
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

function stiffnesAndMassMatrix(mesh::Mesh, order::Int, fun::BasisFunction)
    m = size(mesh.cells, 1)
    n = size(mesh.points, 1)
    K = spzeros(n, n)
    M = spzeros(n, n)
    # dim cst
    dim = size(mesh.points[1], 2)
    form = IntegrationFormula(dim, order)
    p = length(form.weights)
    φ, Dφ = computeφAndDφOnGaußPoints(fun, form)
    for el in 1:m
        indices = mesh.cells[el]
        pts   = mesh.points[indices, :]'
        BK    = mapRefToLocal(pts)
        BK2   = inv(BK'Bk)
        jK    = jacobian(pts)
        mElem = φ * Diagonal(jk.*form.weights)*φ'
        kelem = sum([form.weights[l] * jacobian * Dφ[:,:,l] * BK2 * Dφ[:,:,l]' for l =1:p])
        M += sparse(cartesianProduct(indices, indices)...,mElem[:], n, n)
        K += sparse(cartesianProduct(indices, indices)...,kElem[:], n, n)
    end
    return K,M
end
