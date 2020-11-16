using Test
using MeshDual
@testset "mesh_to_metis" begin

    m = Mesh([[1,2,3],
              [1,2,6],
              [2,6,5],
              [2,5,7],
              [2,7,4],
              [2,4,3]])

    @test mesh_to_metis_fmt(m) == (Cint[0,3,6,9,12,15,18],Cint[0,1,2,0,1,5,1,5,4,1,4,6,1,6,3,1,3,2], Cint(1))
    @test metis_fmt_to_graph(mesh_to_metis_fmt(m)...).adj == m.elements
end

@testset "graph_dual" begin

    m = Mesh([[1,2,3],
              [1,2,6],
              [2,6,5],
              [2,5,7],
              [2,7,4],
              [2,4,3]])

    @test graph_dual(m, 1) == Graph([setdiff([1:6;],[i]) for i=1:6]) 
    @test graph_dual(m, 3) == Graph([ Int64[] for _ in 1:6])
    @test graph_dual(m, 2) == Graph([[2,6], [1,3], [2,4], [3,5], [4,6], [1,5]])
end
