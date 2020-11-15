module MeshDual

export Mesh, Graph, graph_dual, mesh_to_metis_fmt, metis_graph_dual, metis_fmt_to_graph

"""
`Mesh` implements a very basic topological structure for meshes
"""
struct Mesh
    elements::Array{Array{Int64,1},1}
    nodes::Array{Int64,1}
    Mesh(elem::Array{Array{Int64,1},1})=
    begin
        new(elem, sort(reduce(union,elem)))
    end
end

"""
Overloaded equality operator for Meshes : useful in tests
"""
Base.:(==)(a::Mesh, b::Mesh) = Base.:(==)(a.elements, b.elements) && Base.:(==)(a.nodes , b.nodes)


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
e₁ ~ e₂ ↔ e₁,e₂ have n\\_common shared vertices 
"""
function graph_dual(m::Mesh, n_common::Int64)
    T = Dict()
    # build the hash table for each n_common selection
    for (i, e) in enumerate(m.elements)
         for r in gen_parts(e, n_common)
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
        for r in gen_parts(e, n_common)
            union!(adj[i], T[r])
        end
    end
    # suppress reflexive adjacency
    for (i, e) in enumerate(m.elements)
        setdiff!(adj[i], i)
    end
    return Graph(map(x->sort(collect(keys(x.dict))), adj))
end 


function mesh_to_metis_fmt(m::Mesh)
    eptr = Cint[0]
    eind = Cint[] 
    mini_node = Int32(minimum(m.nodes))
    for (i, e) in enumerate(m.elements)
        append!(eptr, eptr[i]+length(e))
        append!(eind, e .- mini_node)
    end
    return (eptr, eind, mini_node)
end 

function metis_fmt_to_graph(eptr::Array{Cint,1}, eind::Array{Cint,1}, min_node::Cint = Cint(1))
    elems = fill(Int64[],size(eptr,1)-1)
    nodes = Int64[]
    for i=1:length(eptr)-1
        elems[i] = eind[eptr[i]+1:eptr[i+1]] .+ min_node
    end
    return Graph(elems)
end

using Libdl: dlopen, dlsym

function metis_graph_dual(m::Mesh, n_common::Int)
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
    eptr, eind, mini_node = mesh_to_metis_fmt(m)
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
    return metis_fmt_to_graph(x_adj, x_adjncy, mini_node)
end 

end # module
