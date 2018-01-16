include("Mesh.jl")
function readMeshFromFileAsciiVtk(fileName::String)
    fp=open(fileName)
    lines=readlines(fp)
    close(fp)
    i = find(lines .== "ASCII") # we ignore everything before ASCII
    return lines
end
