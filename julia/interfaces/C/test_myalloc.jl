using Libdl: dlopen, dlsym
lib_alloc = dlopen("libmyalloc")
all_ptr, fre_ptr, set_ptr, get_ptr = map(x->dlsym(lib_alloc, x), [:my_alloc, :my_free, :set_values, :get_values])


function alloc(n::Int)
    ret = ccall(all_ptr, Int64, (Int64, ), n)
    if (ret == -2) println("allocation table is full") end
    if (ret == -1) println("calloc could not allocate another bloc") end
    return ret
end

function free(num::Int)
    ccall(fre_ptr, Int64, (Int64, ), num)
end

function set_values(num::Int, vals::Array{Float64, 1})
    ret = ccall(set_ptr, Int64, (Int64, Int64, Ptr{Float64}), size(vals, 1), num, vals)
    return ret
end

function get_values(num::Int, vals::Array{Float64, 1})
    ret = ccall(get_ptr, Int64, (Int64, Int64, Ptr{Float64}), size(vals, 1), num, vals)
    return ret
end

h1 = alloc(10)
h2 = alloc(5)
a = collect(1.:10.)
set_values(h1, a)
b = zeros(3)
ret2 = get_values(h1, b)
println("b = $b")
free(h1)
h3 = alloc(1)
h4 = alloc(1)
h5 = alloc(1)
