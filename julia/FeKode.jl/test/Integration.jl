@testset "Integration" begin
@test FeKode.integrate(x->x[1]*x[1], FeKode.IntegrationFormula(1,2)) ≈ 1./3 atol = 1e-12
@test FeKode.integrate(prod,FeKode.IntegrationFormula(2,2)) ≈ 1 ./ 24 atol=1.0e-12 # integrate(x*y,(y,0,1-x),(x,0,1))
@test FeKode.integrate(x->x[1]^2*x[2], FeKode.IntegrationFormula(2,3)) ≈ 1/60. atol= 1e-12 #integrate(x*x*y,(y,0,1-x),(x,0,1))
@test FeKode.integrate(x->x[1]*x[2],FeKode.IntegrationFormula(3,2)) ≈1/120. atol=1e-12 #integrate(x*y,(z,0,1-y-x),(y,0,1-x),(x,0,1))
@test FeKode.integrate(prod,FeKode.IntegrationFormula(3,3)) ≈ 1/720. atol= 1e-12 # integrate(x*y*z,(z,0,1-y-x),(y,0,1-x),(x,0,1))
end
