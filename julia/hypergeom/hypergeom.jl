function powerSeries(a::Real,b::Real,x::Real)
    Tₒ  = one(x)
    Mₒ = one(x)
    Tₙ = Tₒ
    Mₙ = Mₒ
    prec = Real(1e-10)
    flag = true
    i = 0 
    while flag
        Tₙ  = Tₒ * (a+i) / (b+i) * x / (i + 1)
        Mₙ = Mₒ + Tₙ
        flag = abs(Tₙ / Mₙ)  > prec && (abs(Mₙ) > prec || Tₙ > prec)
        i += 1
        Tₒ = Tₙ
        Mₒ = Mₙ
    end
    Mₙ, i
end

function whittaker(k::Real,m::Real,x::Real)
    exp(-x/2.)*x^(m+0.5)*powerSeries(0.5+m-k, 1+2m, x)[1]
end


using SpecialFunctions
using Test
@testset "hypergeom" begin 
   x=3.2
   @test exp(-x*x/2.)/√(π*x)* whittaker(-0.25, 0.25, x*x) ≈ erfc(x) atol=1e-10
end
