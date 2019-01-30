struct Mesh
    points::Array{Float64,2}
    cells::Array{Array{Int}}
end
using PyCall

@pyimport vtk
@pyimport vtk.util as vu
@pyimport vtk.util.numpy_support as vuns
function readMeshFromFileVtk(fileName::String)
    reader=vtk.vtkUnstructuredGridReader()
    reader["SetFileName"](fileName)
    reader["Update"]()
    out = reader[:GetOutput]()
    pts = out[:GetPoints]()
    pointsData = pts[:GetData]()
    #points = convert(Array{Float64,2}, vuns.vtk_to_numpy(pointsData))
    points = vuns.vtk_to_numpy(pointsData)
    nbPoints = size(points, 1)
    clls = out[:GetCells]()
    cllData = clls[:GetData]()
    cellsRaw = vuns.vtk_to_numpy(cllData)
    # Re-organize Cell raw data into an array of array
    i = Int32(1)
    nbCells = out[:GetNumberOfCells]()
    cellIdx =1
    # beware to cast toward Int if the system is 32bits
    cells = fill(Int32[], nbCells)
    while i < size(cellsRaw,1)
         currentCellSize = cellsRaw[i]
         cells[cellIdx] = cellsRaw[i+1:i+currentCellSize]
         i += currentCellSize+1
         cellIdx += 1
    end
    return Mesh(points, cells)
end
