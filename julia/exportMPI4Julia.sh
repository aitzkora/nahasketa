prefix=$HOME/configs/ceps

export JULIA_MPI_C_COMPILER=$prefix/bin/mpicc
export JULIA_MPI_C_INCLUDE_PATH=$prefix/include
export JULIA_MPI_Fortran_INCLUDE_PATH=$prefix/include
export JULIA_MPI_Fortran_COMPILER=$prefix/mpif90
#export JULIA_MPI_C_COMPILER=$prefix/MPI_C_LINK_FLAGS
#export JULIA_MPI_C_COMPILE_FLAGS=$prefix/MPI_C_COMPILE_FLAGS
#export JULIA_MPI_C_LIBRARIES=$prefix/
export JULIA_MPI_Fortran_LIBRARIES="/home/fux/configs/ceps/lib/libmpi_usempif08.so;/home/fux/configs/ceps/lib/libmpi_usempi_ignore_tkr.so;/home/fux/configs/ceps/lib/libmpi_mpifh.so;/home/fux/configs/ceps/lib/libmpi.so"
