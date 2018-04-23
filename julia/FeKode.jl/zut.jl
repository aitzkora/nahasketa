using FeKode
m = FeKode.squareMeshGenerate(0.,1., 0. , 1., 3, 3)
fe = FeKode.P1Basis(2)
M,K = FeKode.stiffnesAndMassMatrix(m, 2, 2, fe)
u = (x,y) -> y*(1-y)x.^3
f = (x,y) -> 6*x*y*(1-y)-2*x.^3
function isOnBoundary(x,y)
    if abs(x) < 1e-20 return true end
    if abs(y) < 1e-20 return true end
    if abs(1-x) < 1e-20 return true end
    if abs(1-y) < 1e-20 return true end
    return false
end
boundary = []
for index = 1:size(m.points,1)
    if isOnBoundary(m.points[index,1:2]...)
        append!(boundary,index)
    end
end
sort!(boundary)
I,J,V=findnz(K)
index = 1
while index < size(J,1)
    pos = searchsorted(boundary,J[index])
    if ~isempty(pos)
        deleteat!(I,index)
        deleteat!(J,index)
        deleteat!(V,index)
    else 
    index += 1
    end
end
Kwb= sparse(I,J,V)
