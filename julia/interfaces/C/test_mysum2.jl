a = collect(1.:10.)
s = ccall((:mysum2, "libmysum2.so"), Float64, (Int64, Ptr{Float64}), size(a, 1), a)
println("s = $s")
