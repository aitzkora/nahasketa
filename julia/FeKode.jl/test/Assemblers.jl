@testset "Assemblers" begin
a = reshape([ gcd(i,j) + 0. for i=1:4 for j=1:3], 3,4)
@test FeKode.mapRefToLocal(a[:,1:2]) ≈ [0, 1, 0] atol=1e-12
@test FeKode.mapRefToLocal(a[:,1:3]) == [0 0; 1 0; 0 2]
@test FeKode.mapRefToLocal(a[:,1:4]) == [0 0 0; 1 0 1; 0 2 0]

@test FeKode.jacobian(a[:,1:2]) == 1
@test FeKode.jacobian(a[:,1:3]) == 2
@test FeKode.jacobian(a[:,1:4]) == 0

## FIXME : add test for others cases than 2D dimension
base = FeKode.P1Basis(2)
m, n = FeKode.computeφAndDφOnGaußPoints(base, FeKode.IntegrationFormula(2, 2))
m_ref = [1 4 1; 4 1 1 ; 1 1 4] / 6.
n_ref = [-1. -1; 1 0; 0 1]
n_ref = repeat(reshape(n_ref,3,2,1), outer=(1,1,3))
@test norm(m - m_ref) ≈ 0. atol = 1.e-12
@test norm(vec(n - n_ref)) ≈ 0. atol = 1.e-12

#
dataDir = joinpath(rootDir, "data")
mesh = FeKode.readMeshFromFileAsciiVtk(joinpath(dataDir, "twoTriangles.vtk"))
@test FeKode.stiffnesAndMassMatrix(mesh, 2, base)

end
