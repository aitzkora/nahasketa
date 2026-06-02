#!/bin/sh
#gfortran -DNDEBUG -O3 -I/home/fux/configs/skotx7.0.12_32/include/ test_mesh_build_elem.F90 -o test_mesh_build_elem.x -L /home/fux/configs/skotx7.0.12_32/lib -lscotch -lscotcherrexit
PREFIX=/home/fux/configs/skotx7.0.12_32/
FFLAGS="-I$PREFIX/include/ -g -DDEBUG -Wuninitialized" #-fsanitize=address 
LDFLAGS="-L$PREFIX/lib -lscotch -lscotcherrexit" # -lasan
gfortran $FFLAGS test_mesh_build_elem.F90 -o test_mesh_build_elem.x  $LDFLAGS
