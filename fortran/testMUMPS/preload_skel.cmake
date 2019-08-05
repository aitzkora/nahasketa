set(PREFIX /path/to/your/prefix)
# MUMPS config
set(MUMPS_INCLUDE_PATH ${PREFIX}/include CACHE STRING "") 
set(MUMPS_LIB_DIR ${PREFIX}/lib/ CACHE STRING "") # must contain libzmumps, libmumps_common, libpord
# METIS config
set(METIS_LIB_DIR ${PREFIX}/lib/ CACHE STRING "") # search for libmetis
# SCOTCH config
set(SCOTCH_LIB_DIR ${PREFIX}/lib CACHE STRING "") # must contain libptesmumps, libscotch, libscotcherr
# SCALAPACK config
set(SCALAPACK_LIB_DIR ${PREFIX}/lib/ CACHE STRING "") # must contain libscalapack or libscalapack-openmpi
# blas/lapack config
set(BLAS_LIB_DIR ${PREFIX}/lib/ CACHE STRING "") # must contain liblas
set(LAPACK_LIB_DIR  ${PREFIX}/lib/ CACHE STRING "") # must contain liblapack
