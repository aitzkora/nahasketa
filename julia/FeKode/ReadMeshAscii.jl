include("Mesh.jl")
function readMeshFromFileAsciiVtk(fileName::String)
    m=Mesh(zeros(0,0),Array{Int64}[])
    fp=open(fileName)
    lines=readlines(fp)
    close(fp)
    if !(lines[3] == "ASCII")
        println("we read only ASCII files")
        return m
    end
    if !(lines[4] == "DATASET UNSTRUCTURED_GRID")
        println("we read only unstructured grid")
        return m
    end
    ptsStr = match(r"\d+",lines[5])
    return lines
end
