module MeshDual

export Mesh, Graph, mesh_dual, mesh_to_metis_fmt, compute_dual_by_metis, grf_dual_ptr, metis_fmt_to_mesh

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


function mesh_to_metis_fmt(m::Mesh)
    eptr = Cint[0]
    eind = Cint[] 
    for (i, e) in enumerate(m.elements)
        append!(eptr, eptr[i]+length(e))
        append!(eind, e .- 1)
    end
    return (eptr, eind)
end 

function metis_fmt_to_mesh(eptr::Array{Cint,1}, eind::Array{Cint,1})
    elems = fill(Int64[],size(eptr,1)-1)
    nodes = Int64[]
    for i=1:length(eptr)-1
        elems[i] = eind[eptr[i]+1:eptr[i+1]]
    end
    return Mesh(elems)
end

using Libdl: dlopen, dlsym

function compute_dual_by_metis(m::Mesh, n_common::Int)
    if "METIS_LIB" in keys(ENV)
        metis_str = ENV["METIS_LIB"]
    else
        metis_str = "/usr/lib/libmetis.so"
    end
    lib_metis = dlopen(metis_str; throw_error=false)
    @debug lib_metis
    @assert lib_metis != nothing
    grf_dual_ptr = dlsym(lib_metis, :libmetis__CreateGraphDual)
    @debug "CreateGraphDual Pointer", grf_dual_ptr
    eptr, eind = mesh_to_metis_fmt(m)
    r_xadj = Ref{Ptr{Cint}}()
    r_adjncy = Ref{Ptr{Cint}}()
    ccall(grf_dual_ptr, Cvoid, 
          (Cint, Cint, Ptr{Cint}, Ptr{Cint}, Cint, Ref{Ptr{Cint}}, Ref{Ptr{Cint}}),
          size(m.elements, 1),
          size(m.nodes, 1),
          eptr,
          eind,
          n_common,
          r_xadj,
          r_adjncy
         )
    x_adj = [unsafe_load(r_xadj[] ,i) for i=1:length(m.elements)]
    x_adjncy = [unsafe_load(r_adjncy[],i) for i=1:x_adj[end] ]
    return x_adj, x_adjncy
    #return metis_fmt_to_mesh(x_adj, x_adjncy)
end 

end # module
