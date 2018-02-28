include("squareGenerate.jl")
include("computeLaplacian.jl")
N = 2
L = 6.
m = squareMeshGenerate(0., L, 0., L, N, N)
computeLaplacian(m)
