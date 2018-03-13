function readMeshFromFileAsciiVtk(fileName::String)
    m=Mesh(zeros(0,0),Array{Int64}[])
    fp=open(fileName)
    lines=readlines(fp)
    close(fp)
    filter!(x->x≠"",lines)
    if !(lines[3] == "ASCII")
        println("we read only ASCII files")
        return m
    end
    if !(lines[4] == "DATASET UNSTRUCTURED_GRID")
        println("we read only unstructured grid not", lines[4])
        return m
    end
    ptsStr = match(r"POINTS \d+ float", lines[5]);
    if (ptsStr.match === nothing)
        println("cannot read the number of Points → ", lines[5])
    else
        nbPts = parse(Int, split(ptsStr.match)[2])
    end
    # extract the matrix of points
    pts = hcat([map(x->parse(Float64,x),split(lines[i])) for i in 6:6 + nbPts-1]...)'
    # extract cell data
    cellOffset = nbPts + 6
    cellStr = match(r"CELLS \d+ \d+", lines[cellOffset])
    if (cellStr.match === nothing)
        println("cannot read the line containing cells spec → ", lines[cellOffset])
    else
         nbCells, nbCellScalars= map(x->parse(Int, x), split(cellStr.match)[2:3])
    end
    cells = Array{Array{Int64}}(nbCells)
    for i in cellOffset + 1 : cellOffset + nbCells
       ints = map(x->parse(Int, x), split(lines[i]))
       cells[i-cellOffset] = ints[2:end]
    end
    return Mesh(pts, cells)
end
