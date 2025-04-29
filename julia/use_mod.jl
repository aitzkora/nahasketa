using Libdl
libmod = dlopen("./modify.so")
mod_ptr = dlsym(libmod, :modify_)
a = [1.,2.,3.]

function plus_un_ptr!(x::Ptr{Float64}) 
    unsafe_store!(x, unsafe_load(x,1)+1, 1)
    nothing
end
plus_un_c = @cfunction(plus_un_ptr!, Cvoid, (Ptr{Float64},))
ccall(mod_ptr, Cvoid, (Ptr{Cvoid}, Ref{Cint}, Ptr{Float64}), plus_un_c, 3, a)
println(a)
