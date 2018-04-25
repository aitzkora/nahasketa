using FeKode
m = FeKode.squareMeshGenerate(0.,1., 0. , 1., 3, 3)
fe = FeKode.P1Basis(2)
M,K = FeKode.stiffnesAndMassMatrix(m, 2, 2, fe)
u = (x,y,z) -> y.*(1-y).*x.^3
f = (x,y,z) -> 6*x.*y.*(1-y)-2*x.^3
F = f(m.points[:,1], m.points[:,2], m.points[:,3])

#determine boundary
boundary =  m.isOnBoundary;
sort!(boundary)

# substract boundary contribution to the right hand side
F -= K[:, boundary] * u(m.points[boundary,1], m.points[boundary,2], m.points[boundary,3])
indexes=filter(x->isempty(searchsorted(boundary,x)),1:size(F,1))
Fn = sparsevec((1:size(F,1))[indexes], F[indexes])

# suppress rows and columns from the K matrix
I,J,V=findnz(K)
In = Int64[]
Jn = Int64[]
Vn = Float64[]

for i = 1:size(I, 1)
    IIsNotBoundary = isempty(searchsorted(boundary, I[i]))
    JIsNotBoundary = isempty(searchsorted(boundary,J[i]))
    if IIsNotBoundary && JIsNotBoundary
        append!(In, I[i])
        append!(Jn, J[i])
        append!(Vn, V[i])
    end
end
Kn= sparse(In,Jn,Vn)
un = Kn\Fn
