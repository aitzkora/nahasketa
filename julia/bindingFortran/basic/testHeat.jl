include("heat.jl")
N =10
a = zeros(N, N)
a[1, :] .= 1.
a[end, :] .= 1.
a[:, 1] .= 1.
a[:, end] .= 1.
b = copy(a)
err = heat(a, b)
