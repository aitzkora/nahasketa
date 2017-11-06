function massMatrix(m::Mesh)
   nCells = size(Cells,1)
   for t=1:nCells
      indices=m.cells[t]
   en
end

function jacobian1d(x::Array{Float64,2})
    return norm(x[:,1])
end

function jacobian2d(x::Array{Float64,2})
   return norm(cross(x[:,1], x[:,2]))
end
function jacobian3d(x::Array{Float64,2})
   return abs(det(x))
end
