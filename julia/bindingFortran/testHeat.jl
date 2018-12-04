include("heat.jl")
N = 5
hx = 1 / (N-1)
a = zeros(N, N)
a[1, :] .= 1.
a[end, :] .= 1.
a[:, 1] .= 1.
a[:, end] .= 1.
b = copy(a)
dt = hx^2 / 4.
err = heat(hx, hx, dt, a, b)
