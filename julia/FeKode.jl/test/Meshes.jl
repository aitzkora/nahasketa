@testset "Mesh Generation" begin
# test on a very simple square
m1 = FeKode.meshGenerate2D(0., 1., 0., 1., 2, 2)
@test m1.cells == [[1, 2, 4], [1, 4, 3]]
@test m1.points == [[0. 0. 0.]; [0. 1. 0.];  [1. 0. 0.]; [1. 1. 0.];]
@test m1.isOnBoundary == 1:4

# test on a very simple line 
m2 = FeKode.meshGenerate1D(0., 1., 2)
@test m2.cells == [[1, 2], [2, 3]]
@test m2.points == [[0. 0. 0.]; [0.5 0. 0.];  [1. 0. 0.]; ]
@test m2.isOnBoundary == [ 1, 3];
end
