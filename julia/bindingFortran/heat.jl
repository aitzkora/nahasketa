function heat(hx::Float64, hy::Float64, dt::Float64, uᵢₙ::Array{Float64,2}, uₒᵤₜ::Array{Float64,2})
    @assert size(uₒᵤₜ) == size(uᵢₙ)
    (size_x, size_y) = size(uₒᵤₜ)
    size_x = Int32(size_x) # could overflows
    size_y = Int32(size_y)
    err = 1e8
    ccall((:heatKernel, "./libheatKernel.so"), Int32, (Ref{Float64}, Ref{Float64}, Ref{Float64}, Ref{Int32}, Ref{Int32}, Ptr{Float64}, Ptr{Float64}, Ref{Float64}), hx, hy, dt, size_x, size_y, uᵢₙ, uₒᵤₜ, err)
    return err
end
