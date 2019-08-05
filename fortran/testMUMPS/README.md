testMUMPS 
---------
this is a simple Cmake project to compile against MUMPS linear solver (in complex, e.g. libzmumps)
to use 
copy preload_skel.cmake to preload.cmake and edit it

prerequisites: 
--------------
 - you need to install MPI, MUMPS (in parallel mode), METIS, SCOTCH, SCALAPACK, BLAS and LAPACK
compilation 
-----------
- mkdir -p build && cd build && cmake -C ../preload.cmake && make && make test

Credits
-------
- zsimpletest.F90 is adapted from the MUMPS project
- input_data is take directly from the MUMPS project
