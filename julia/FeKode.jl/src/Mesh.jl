type Mesh
    points::Array{Float64,2}
    cells::Array{Array{Int}}
    isOnBoundary::Array{Int,1}
end
