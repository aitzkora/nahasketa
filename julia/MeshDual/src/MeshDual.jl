module MeshDual

export Mesh, Graph, mesh_dual, mesh_to_metis_fmt, compute_dual_by_metis, grf_dual_ptr, lib_metis

"""
`Mesh` implements a very basic topological structure for meshes
"""
struct Mesh
    elements::Array{Array{Int64,1},1}
    nodes::Array{Int64,1}
    Mesh(elem::Array{Array{Int64,1},1})=
    begin
        new(elem, unique(reduce(vcat,elem)))
    end
end

"""
graph structure
"""
struct Graph
    adj::Array{Array{Int64,1},1}
end

using Test

"""
gen_parts(l::Array{Int64,1}, k::Int)

generates an Array contaning the (#l choose k) sets of k elements in the set l
"""
function gen_parts(l::Array{Int64,1}, k::Int64)
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

""" 
mesh\\_dual(m::Mesh, nb\\_comp\\_pts::Int64)

Compute the elements graph of the Mesh m respect to the following adjacency
relationship
e₁ ~ e₂ ↔ e₁,e₂ have nb\\_comp\\_pts shared vertices 
"""
function mesh_dual(m::Mesh, nb_comp_pts::Int64)
    g = Array{Array{Int64}}[]
    T = Dict()
    # build the hash table for each nb_comp_pts selection
    for (i, e) in enumerate(m.elements)
         for r in gen_parts(e, nb_comp_pts)
              if (! haskey(T, r) )
                  T[r] = Set([i])
              else
                  push!(T[r],i)
              end
         end
    end
    for ke in T
        @debug Tuple(ke.first), " → " ,typeof(ke.second)
    end
    #now build adjacency
    adj = [ Set{Int64}() for _ in 1:length(m.elements)]
    for (i, e) in enumerate(m.elements)
        for r in gen_parts(e, nb_comp_pts)
            union!(adj[i], T[r])
        end
    end
    return adj
end 

@testset "mesh_dual" begin

    m = Mesh([[1,2,3],
              [1,2,6],
              [2,6,5],
              [2,5,7],
              [2,7,4],
              [2,4,3]])

    @test mesh_dual(m, 1) == [ Set([1:6;]) for _ in 1:6]
    @test mesh_dual(m, 3) == [ Set([i]) for i in 1:6]
    @test mesh_dual(m, 2) == Set.(union.([[2,6], [1,3], [2,4], [3,5], [4,6], [1,5]], [[i] for i in 1:6]))
end


function mesh_to_metis_fmt(m::Mesh)
    eptr = [0]
    eind = Int64[] 
    for (i, e) in enumerate(m.elements)
        append!(eptr, eptr[i]+length(e))
        append!(eind, e)
    end
    return (eptr, eind)
end 


# try to use a function from metis 
using Libdl: dlopen, dlsym

function compute_dual_by_metis(m::Mesh, n_common::Int)
    if "METIS_LIB" in keys(ENV)
        metis_str = ENV["METIS_LIB"]
    else
        metis_str = "/usr/lib/libmetis.so"
    end
    lib_metis = dlopen(metis_str; throw_error=false)
    @info lib_metis
    @assert lib_metis != nothing
    grf_dual_ptr = dlsym(lib_metis, :libmetis__CreateGraphDual)
    @info "CreateGraphDual Pointer", grf_dual_ptr
    eptr, eind = mesh_to_metis_fmt(m)
    #r_xadj = Ref{Ptr{Cint}}[]
    #r_adjncy = Ref{Ptr{Cint}}[]
    #ccall(grf_dual_ptr, Cvoid, 
    #      (Cint, Cint, Ptr{Cint}, Ptr{Cint}, Cint, Ref{Ptr{Cint}}, Ref{Ptr{Cint}}),
    #      size(m.elements, 1),
    #      size(m.nodes, 1),
    #      eptr,
    #      eind,
    #      n_common,
    #      r_xadj,
    #      r_adjncy
    #     )
    #return r_xadj[], r_adjncy[]
end 

end # module
