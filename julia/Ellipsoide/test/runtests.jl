using Test
using Ellipsoide
using LinearAlgebra
@testset "Newton" begin
  @test newton1D(x->x^2-2, x->2. *x, 1.)[1] ≈ √2
end


@testset "proj_diag" begin

    N = 10
    x = 1 .+rand(N)
    @test norm(proj_ellipsoide_diag(ones(N), x) - x ./ norm(x)) < 1e-10

end

