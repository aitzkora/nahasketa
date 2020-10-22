struct Mesh
    elements::Array{Array{Int64}}
end

struct Graph
    adj::Array{Array{Int64}}
end

using Test

"""
gen_parts(l::Array{Int}, k::Int)

generates an Array contaning the (#l choose k) sets of k elements in the set l
"""
function gen_parts(l::Array{Int64}, k::Int64)
    n = size(l, 1)
    gen =[ (1:n) .*i for i in filter(x->sum(x)==k,digits.(0:2^n-1,base=2, pad=n))] 
    return map(x->Set(l[x]), setdiff.(unique.(gen),[0]))
end 

@testset "gen_parts_test" begin
   l = [1, 2, 4]
   @test Set(gen_parts(l, 2)) == Set(Set.([(1,2),(1,4),(2,4)]))
   @test Set(gen_parts(l, 1)) == Set(Set.([(1),(2),(4)])) 
   @test Set(gen_parts(l, 3)) == Set(Set.([(1,2,4)])) 
end

function mesh_dual(m::Mesh, nbComPts::Int64)
    g = Array{Array{Int64}}[]
    T = Dict()
    # build the hash table for each nbComPts selection
    for (i, e) in enumerate(m.elements)
         for r in gen_parts(e, nbComPts)
              if (! haskey(T, r) )
                  T[r] = Set([i])
              else
                  push!(T[r],i)
              end
         end
    end
    for ke in T
        println(Tuple(ke.first), " → " ,typeof(ke.second))
    end
    #now build adjacency
    typeof(T)
    adj = Set{Int64}[], length(m.elements))
    for (i, e) in enumerate(m.elements)
        for r in gen_parts(e, nbComPts)
            println(typeof(adj[i]))
            #union!(adj[i], T[r])
        end
    end
    return adj
end 
@testset "bidon" begin
    m  = Mesh([[1,2,3],
              [1,2,6],
              [2,6,5],
              [2,5,7],
              [2,4,4],
              [2,4,3]])
end
