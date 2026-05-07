#!/bin/sh
#gfortran -DNDEBUG -O3 -I/home/fux/configs/skotx7.0.12_32/include/ test_mesh_build_elem.F90 -o test_mesh_build_elem.x -L /home/fux/configs/skotx7.0.12_32/lib -lscotch -lscotcherrexit
gfortran -DDEBUG -Wuninitialized -g -I/home/fux/configs/skotx7.0.12_32/include/ test_mesh_build_elem.F90 -o test_mesh_build_elem.x -L /home/fux/configs/skotx7.0.12_32/lib -lscotch -lscotcherrexit
