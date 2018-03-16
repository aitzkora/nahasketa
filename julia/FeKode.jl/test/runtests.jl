using Base.Test
using FeKode
rootDir = dirname(dirname(Base.functionloc(FeKode.eval, Tuple{Void})[1]))
myTests = [ "Basis", "Integration", "Assemblers", "Meshes"]
@testset "FeKode" begin
    for t in myTests
        include("$(t).jl")
    end
end
