@testset "Mesh Generation" begin
# test on a very simple square
mk1 = FeKode.squareMeshGenerate(0., 1., 0., 1., 2, 2)
@test m1.cells == [[1, 2, 4], [1, 4, 3]]
@test m1.points == [[0. 0. 0.]; [0. 1. 0.];  [1. 0. 0.]; [1. 1. 0.];]
@test m1.isOnBoundary == 1:4
end
