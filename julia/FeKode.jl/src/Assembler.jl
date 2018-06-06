"""
create the Bₖ matrix which corresponds to the linear map  from the 
reference element ``T = \{ (x,y,z) : x,y,z ≥ 0 x+y+z = 1 \}` to the
current triangle ``Tₖ = (P¹ , ⋯ , Pᵐ )``

# Arguments :
* x : a 3 x m matrix containing all the points of the current element
# Returns :
``Bₖ = [ Pᵐ- P¹, ⋯ , P² - P¹]``
"""
function mapRefToLocal(x::Array{Float64,2})
    @assert(size(x, 1) == 3)
    return x[:,2:end].-x[:,1:1] # or cumsum(diff(x,2),2)
end

"""
jacobian(x)

"""
function jacobian(x::Array{Float64,2})
    m = mapRefToLocal(x)
    n = size(m, 2)
    #F = svdfact(m)
    F = qrfact(m)
    return abs(prod(diag(F[:R])))
end
"""
computeφAndDφOnGaußPoints(fun::BasisFunction, form::IntegrationFormula)

   Apply the basis functions on Gauß points (functions on rows, points on columns)

"""

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

# Examples

julia> cartesianProduct([2,4],[1,2,3])
([2, 2, 2, 4, 4, 4], [1, 2, 3, 1, 2, 3])

"""
function cartesianProduct(x,y)
    return repeat(x,inner=size(y,1)),repeat(y,outer=size(x,1))
end

function stiffnesAndMassMatrix(mesh::Mesh, dim::Int, order::Int, fun::BasisFunction)
    m = size(mesh.cells, 1)
    n = size(mesh.points, 1)
    K = spzeros(n, n)
    M = spzeros(n, n)
    # dim cst
    form = IntegrationFormula(dim, order)
    p = length(form.weights)
    φ, Dφ = computeφAndDφOnGaußPoints(fun, form)
    for el in 1:m
        indices = mesh.cells[el]
        pts   = mesh.points[indices, :]'
        Bₖ    = mapRefToLocal(pts)
        invBₖ = inv(Bₖ'Bₖ)
        Jₖ    = jacobian(pts)
        mElem = φ * Diagonal(Jₖ .* form.weights) * φ'
        kElem = sum([form.weights[l] * Jₖ * Dφ[:,:,l] * invBₖ * Dφ[:,:,l]' for l =1:p])
        M += sparse(cartesianProduct(indices, indices)..., mElem[:], n, n)
        K += sparse(cartesianProduct(indices, indices)..., kElem[:], n, n)
    end
    return K,M
end


"""
    removeRowsAndColsAndPutOnes(M::SparseMatrixCSC, indices::Array{Int64})

Return a sparse matrix equal to `M` but with columns and rows with indexes
in `indices` removed and replaced by ones on the diagonal

# Example
```jldoctest

julia> A=(1:3).^(1.:3.)'
3×3 Array{Float64,2}:
 1.0  1.0   1.0
 2.0  4.0   8.0
 3.0  9.0  27.0

julia> FeKode.removeRowsAndColsAndPutOnes(sparse(A),[1,3])
3×3 SparseMatrixCSC{Float64,Int64} with 3 stored entries:
  [1, 1]  =  1.0
  [2, 2]  =  4.0
  [3, 3]  =  1.0
```
"""
function removeRowsAndColsAndPutOnes(M::SparseMatrixCSC{Float64,Int64}, indices::Array{Int64})
    Ii, Ji, Vi=findnz(M)
    In = Int64[]
    Jn = Int64[]
    Vn = Float64[]

    boundary = sort(indices)
    for i = 1:size(Ii, 1)
        IIsNotBoundary = isempty(searchsorted(boundary, Ii[i]))
        JIsNotBoundary = isempty(searchsorted(boundary, Ji[i]))
        if IIsNotBoundary && JIsNotBoundary
            append!(In, Ii[i])
            append!(Jn, Ji[i])
            append!(Vn, Vi[i])
        end
    end
    append!(In, boundary)
    append!(Jn, boundary)
    append!(Vn, ones(size(boundary)))
    return sparse(In,Jn,Vn)
end
