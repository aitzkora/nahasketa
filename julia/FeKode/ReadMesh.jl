type Mesh
    points::Array{Float64,2}
    cells::Array{Int32,2}
end
using PyCall
unshift!(PyVector(pyimport("sys")["path"]),"/home/fux/configs/VTK8/lib/python2.7/site-packages/")
@pyimport vtk
@pyimport vtk.util as vu
@pyimport vtk.util.numpy_support as vuns
function readMeshFromFile(fileName::String)
    reader=vtk.vtkUnstructuredGridReader()
    reader["SetFileName"](fileName)
    reader["Update"]()
    out = reader[:GetOutput]()
    pts = out[:GetPoints]()
    pointsData = pts[:GetData]()
    points = vuns.vtk_to_numpy(pointsData)
    clls = out[:GetCells]()
    cllData = clls[:GetData]()
    cellsRaw = vuns.vtk_to_numpy(cllData)
    i = 1
    nbCells = out[:GetNumberOfCells]()
    cellIdx =1
    cells = fill(Int32[],nbCells)
    while i < size(cellsRaw)[1]
         currentCellSize = cellsRaw[i]
         println("domain = $(i+1)-$(i+currentCellSize)")
         cells[cellIdx] = cellsRaw[i+1:i+currentCellSize]
         i += currentCellSize+1
         cellIdx += 1
    end
    return points,cells
end
