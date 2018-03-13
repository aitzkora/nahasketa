"""
generate a plane mesh for the square [xMin, xMax] x [ yMin, yMax] with nX x nY points
beware that cells indexing begins to 1 (for julia, not zero (vtk))
"""
function squareMeshGenerate(xMin::Float64, xMax::Float64, yMin::Float64, yMax::Float64, nX::Int, nY::Int)
   x=linspace(xMin, xMax, nX)
   y=linspace(yMin, yMax, nY)
   points = hcat([[i,j,0.] for i in x for j in y]...)'
   cells = vcat([vcat([(i-1)*nX+j (i-1)*nX+j+1 i*nX+j+1],[(i-1)*nX+j i*nX+j+1 i*nX+j]) for i=1:nX-1 for j=1:nY-1]...)
   return Mesh(points ,[cells[i,:] for i=1:size(cells,1)])
end
