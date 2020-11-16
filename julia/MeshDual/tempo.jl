using MeshDual

ENV["METIS_LIB"]="/home/fux/sources/metis_modify/build/libmetis/libmetis.so"

m = Mesh([[1,2,3],
          [1,2,6],
          [2,6,5],
          [2,5,7],
          [2,7,4],
          [2,4,3]])

ptr, ind, ne  = mesh_to_scotch_fmt(m)
adj =  graph_dual_new(m, 1)
#m1 = metis_graph_dual(m, 1)
#m2 = metis_graph_dual(m, 2)
#m3 = metis_graph_dual(m, 3)
#
#m1p = graph_dual(m, 1)
#m2p = graph_dual(m, 2)
#m3p = graph_dual(m, 3)
#
#@assert m1 == m1p
#@assert m2 == m2p
#@assert m3 == m3p # Sadly metis computes a strange result!
