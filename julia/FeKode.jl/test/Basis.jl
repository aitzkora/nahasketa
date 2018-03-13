@testset "Basis Functions" begin
    for n=1:3
        basis = FeKode.P1Basis(n)
        λ = rand(n+1)
        λ = λ / sum(λ)
        vertices = [zeros(n,1) eye(n)]
        x = vertices * λ
        @test sum([basis.φ[j](x) for j in 1:(n+1)]) ≈ 1. atol=1e-12
        @test norm(sum(reshape([basis.Dφ[i,j](x) for i=1:(n+1) for j=1:n],n,n+1),2))==0
    end
end
