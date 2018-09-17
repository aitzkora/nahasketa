# taken from https://discourse.julialang.org/t/parallel-is-very-slow/9443/15
# and adapted
using Base.Threads, BenchmarkTools, Statistics

f(x) = sin(x) + cos(x)

function serial(n)
    s = 0.0
    for x = 1:n
        s += f(x)
    end
    return s
end

function threads(n)
    res_vec = zeros(nthreads())
    @threads for i ∈ 1:nthreads()
        res_vec[i] = local_sum(threadid(), n, nthreads())
    end
    sum(res_vec)
end

function parallel(n)
    @distributed (+) for x = 1:n
        f(x)
    end
end


function local_sum(id, n, nthread)
    out = 0.0
    l = 1 + div(n * (id-1), nthread)
    u = div(n * id, nthread)
    for x ∈ l:u
        out += f(x)
    end
    out
end

N = 5
trial = Array{BenchmarkTools.Trial,2}(undef,N,3)
times = zeros(N,3)

for i = 1:N
    n = 10^i
    println("i = ", i)
    @assert isapprox(serial(n), threads(n))
    trial[i,1] = @benchmark serial($n)
    trial[i,2] = @benchmark threads($n)
    trial[i,3] = @benchmark parallel($n)
    times[i,1] = median(trial[i,1].times)
    times[i,2] = median(trial[i,2].times)
    times[i,3] = median(trial[i,3].times)
end

# print result times
println(times)
