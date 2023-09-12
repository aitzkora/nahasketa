
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

function track2lines(nodes, triangles, track)
    bar = x->sum(nodes[triangles[x,:],:] / 3., dims=1)
    init = bar(i)
    for pt in track
        curr = bar(pt)
    end
     
end
nodes = read_with_dim("x_node.txt",Float64)'
triangles = read_with_dim("cell_node.txt",Int64)'
pt_search, tr = read_track("track_1.txt")
fig, ax, plot = poly(nodes, triangles, strokewidth=1, shading=false, alpha=1.)
