function ex1(A)
    m,n = size(A)
    @assert m == n
    ccall((:eye, "./matrix.so"), Int32, (Ref{Int32}, Ptr{Float64}), n, A)
end
A=zeros(3,3)
ex1(A)
println(A)
