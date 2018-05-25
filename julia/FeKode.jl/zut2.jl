using FeKode
m = FeKode.meshGenerate1D(0.,1., 10)
fe = FeKode.P1Basis(1)
M, K = FeKode.stiffnesAndMassMatrix(m, 2, 2, fe)
u = (x,y,z) -> x.^3
f = (x,y,z) -> 6*x
F = f(m.points[:,1], m.points[:,2], m.points[:,3])

#determine boundary
boundary =  m.isOnBoundary;
sort!(boundary)

# substract boundary contribution to the right hand side
F -= K[:, boundary] * u(m.points[boundary,1], m.points[boundary,2], m.points[boundary,3])
F[boundary] = u(m.points[boundary,1], m.points[boundary,2], m.points[boundary,3])

# suppress rows and columns from the K matrix
I,J,V=findnz(K)
In = Int64[]
Jn = Int64[]
Vn = Float64[]

for i = 1:size(I, 1)
    IIsNotBoundary = isempty(searchsorted(boundary, I[i]))
    JIsNotBoundary = isempty(searchsorted(boundary, J[i]))
    if IIsNotBoundary && JIsNotBoundary
        append!(In, I[i])
        append!(Jn, J[i])
        append!(Vn, V[i])
    end
end
append!(In, boundary)
append!(Jn, boundary)
append!(Vn, ones(size(boundary)))

Kn= sparse(In,Jn,Vn)
sol=Kn\F
