using Test
function heatKernelSeq(X)
    H = zeros(size(X))
    H[2:end-1, 2:end-1] =  4. * X[2:end-1, 2:end-1] - X[1:end-2, 2:end-1] - X[3:end, 2:end-1]  - X[2:end-1, 1:end-2] - X[2:end-1, 3:end] 
    return H
end

function heatKernelWithLoop(X)
    H = zeros(size(X))
    m, n = size(H)
    for i = 2:m-1
        for j = 2:n-1
            H[i,j] = 4. * X[i, j] - X[i-1,j] - X[i+1, j] - X[i, j+1] - X[i, j-1]
        end
    end
    return H
end

function heatKernelThread(X)
    H = zeros(size(X))
    m, n = size(H)
    Threads.@threads for i = 2:m-1
        for j = 2:n-1
            H[i,j] = 4. * X[i, j] - X[i-1,j] - X[i+1, j] - X[i, j+1] - X[i, j-1]
        end
    end
    return H
end

function putZerosOnBorder!(X::Array{Float64,2})
   X[1,: ] .= 0
   X[end,: ] .= 0
   X[:, end ] .= 0
   X[:, 1 ] .= 0
end

X=rand(10, 10)
putZerosOnBorder!(X)
@test (sum(X[:,1].^2) + sum(X[:, end].^2) + sum(X[end, :].^2) + sum(X[1,:].^2)) ≈ 0 atol=1e-10

#@test heatKernelWithLoop(X) ≈ heatKernelSeq(X) atol=1e-10
#@test heatKernelWithLoop(X) ≈ heatKernelThread(X) atol=1e-10

using BenchmarkTools
N = 5
trial = Array{BenchmarkTools.Trial,2}(undef,N,3)
times = zeros(N,3)
import Statistics:median
for i = 4:4
    n = 10^i
    println("i = ", i)
    X = rand(n,n)
    putZerosOnBorder!(X)
    #trial[i,1] = @benchmark heatKernelSeq(X)
    trial[i,2] = @benchmark heatKernelThread(X)
    trial[i,3] = @benchmark heatKernelWithLoop(X)
    #times[i,1] = median(trial[i,1].times)
    times[i,2] = median(trial[i,2].times)
    times[i,3] = median(trial[i,3].times)
end

# print result times
println(times)
