
function read_with_dim(filename, T)
    file = open(filename)
    first = readline(file)
    numbers  = map(x->parse(Int,x),split(first))
    nb_cols = numbers[1]
    nb_rows = numbers[2]
    nums = reshape(map(x->parse(T,x),split(readline(file))),nb_cols, nb_rows)
    close(file)
    return nums
end

function read_track(filename)
    file = open(filename)
    parseF = x->parse(Float64,x)
    pt = map(parseF, split(readline(file)))
    track = map(parseF, eachline(file))
    return pt, track
end 

toTuple(z) = (x->tuple(x...)).(eachcol(z))
nodes = toTuple(read_with_dim("x_node.txt",Float64))
triangles = toTuple(read_with_dim("cell_node.txt",Int64))
using Meshes

m = SimpleMesh(nodes, connect.(triangles))
using GLMakie
viz(m, showfacets=true)
