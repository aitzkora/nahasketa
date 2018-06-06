@testset "Assemblers" begin
a = reshape([ gcd(i,j) + 0. for i=1:4 for j=1:3], 3,4)
@test FeKode.mapRefToLocal(a[:,1:2]) ≈ [0, 1, 0] atol=1e-12
@test FeKode.mapRefToLocal(a[:,1:3]) == [0 0; 1 0; 0 2]
@test FeKode.mapRefToLocal(a[:,1:4]) == [0 0 0; 1 0 1; 0 2 0]

@test FeKode.jacobian(a[:,1:2]) == 1
@test FeKode.jacobian(a[:,1:3]) == 2
@test FeKode.jacobian(a[:,1:4]) == 0

## FIXME : add test for others cases than 2D dimension
basis = FeKode.P1Basis(2)
m, n = FeKode.computeφAndDφOnGaußPoints(basis, FeKode.IntegrationFormula(2, 2))
m_ref = [1 4 1; 4 1 1 ; 1 1 4] / 6.
n_ref = [-1. -1; 1 0; 0 1]
n_ref = repeat(reshape(n_ref,3,2,1), outer=(1,1,3))
@test norm(m - m_ref) ≈ 0. atol = 1.e-12
@test norm(vec(n - n_ref)) ≈ 0. atol = 1.e-12

#
dataDir = joinpath(rootDir, "data")
mesh = FeKode.readMeshFromFileAsciiVtk(joinpath(dataDir, "twoTriangles.vtk"))
FeKode.stiffnesAndMassMatrix(mesh, 2, 2, basis)

# removeRowsAndColsAndPutOnes
x = [1, 3, 4]
M = sparse(FeKode.cartesianProduct(x,x)...,1:9*1.)
Mᵣ = FeKode.removeRowsAndColsAndPutOnes(M, [1, 3])
v = Float64[0, 1, 0]
Mᵥ = [eye(3) - v*v' zeros(3,1); zeros(1,3) 9]
@test norm(Mᵣ-Mᵥ) ≈ 0. atol = 1e-24

#1D test with laplacian
N = 10
m = FeKode.meshGenerate1D(0.,1., N)
fe = FeKode.P1Basis(1)
K, M = FeKode.stiffnesAndMassMatrix(m, 1, 2, fe)
x = m.points[:,1]
u = x.^3
f = -6*x
F = M * f

##determine boundary
boundary =  m.isOnBoundary;

# substract boundary contribution to the right hand side
F -= K[:, boundary] * u[boundary]
F[boundary] = u[boundary]

# suppress rows and columns from the K matrix
Kn = FeKode.removeRowsAndColsAndPutOnes(K, boundary)

# retrieve the solution
sol=Kn\F
@test norm(sol-u) ≈ 0. atol = 1e-12
end
