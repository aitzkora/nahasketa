using GLMakie

# read a matrix of the following format
# nb_rows, nb_cols
# data on one line
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
    pt = (x->parse(Float64,x)).(split(readline(file)))
    track = (α->parse(Int64,α)).(eachline(file))
    close(file)
    return pt, track
end 

nodes = read_with_dim("x_node.txt",Float64)'
triangles = read_with_dim("cell_node.txt",Int64)'
п, track = read_track("track_1.txt")
bars = sum(nodes[triangles[tr,:],:] / 3., dims=2)[:,1,:]
fig, ax, plot = poly(nodes, triangles, strokewidth=1, shading=false, alpha=1.)
p₀ = sum(nodes[triangles[1,:],:] / 3., dims=2)[:,:]

function circle!(ax, p, col, r::Float64 = 0.1, N::Int64 = 10)
     α = LinRange(0.,2π, N)
     x = p[1] .+ r * cos.(α)
     y = p[2] .+ r *  sin.(α)
     lines!(ax, x, y; color = col, linewidth=5)
end

lines!(ax, bars[:,1], bars[:,2]; color = :red)
circle!(ax, п, :red, 0.01, 10)
circle!(ax, p₀, :green, 0.00001, 100)
text!(ax, bars[1,1], bars[1,2]; text="depart")
display(fig)
