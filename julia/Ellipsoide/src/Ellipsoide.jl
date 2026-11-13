module Ellipsoide

# general imports
using LinearAlgebra
using Optim
using Infiltrator
using Revise

# Newton's method
include("newton.jl")
export newton1D, proj_ellipsoide_diag 

# problem generators
include("genProblems.jl")
export getSimpleProblem, getProblem, expe

#include ("findRoot.jl")
#export  proj_ellipsoide_root

# lin-han algorithms
include("LinHan.jl")
export lin_han

# ADMM variants
include("ADMM.jl")
export ADMM, ADMM_diag, ADMM_S_diag

end # module Ellipsoide
