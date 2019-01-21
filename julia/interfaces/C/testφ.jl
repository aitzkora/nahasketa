φ1(x) = ccall((:phi1, "phi1"), Float64, (Float64,), (Float64(x),))

φ2(x) = ccall((:phi2, "phi1"), Float64, (Float64,), (Float64(x),))
