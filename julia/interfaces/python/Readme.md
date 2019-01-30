# Julia Binding for reading a Unstructured Mesh with VTK

# Requirements
 - the package PyCall 
 - a version of VTK (test with VTK-8.2) compiled against the same python version
# using
 - launch LD_LIBRARY_PATH="path/to/vtk/lib:path/to/vtk.py/file" PYTHONPATH="path/to/vtk.py/file" julia
 - julia> a=readMeshFromFileVtk("twoTriangles.vtk")
