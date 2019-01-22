a = reshape(collect(1.:10.), 5, 2)
s = ccall((:mysum, "libmysum.so"), Float64, (Int64, Int64, Ptr{Float64}), size(a, 1), size(a, 2), a)
println("s = $s")
