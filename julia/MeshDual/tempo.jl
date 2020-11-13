using MeshDual

ENV["METIS_LIB"]="/home/fux/sources/metis_modify/build/libmetis/libmetis.so"

m = Mesh([[1,2,3],
          [1,2,6],
          [2,6,5],
          [2,5,7],
          [2,7,4],
          [2,4,3]])
a,b = compute_dual_by_metis(m, 2)
