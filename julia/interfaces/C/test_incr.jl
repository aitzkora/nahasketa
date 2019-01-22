using Libdl
a = Ref{Cint}(12);
ccall((:increment, "libincrement.so"), Cvoid, (Ref{Cint},), a);
println(a[])
