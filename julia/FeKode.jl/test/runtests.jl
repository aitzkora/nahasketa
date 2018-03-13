using Base.Test
using FeKode
myTests = [ "Basis", "Integration", "Assemblers", "Meshes"]
@testset "FeKode" begin
    for t in myTests
        include("$(t).jl")
    end
end
