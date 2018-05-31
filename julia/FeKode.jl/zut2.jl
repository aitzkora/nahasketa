using FeKode
N= 10
m = FeKode.meshGenerate1D(0.,1., N)
fe = FeKode.P1Basis(1)
K, M = FeKode.stiffnesAndMassMatrix(m, 1, 2, fe)
X = m.points[:,1]
u = (x,y,z) -> x.^3
f = (x,y,z) -> -6*x
F = M * f(m.points[:,1], m.points[:,2], m.points[:,3])

#determine boundary
boundary =  m.isOnBoundary;
sort!(boundary)

# substract boundary contribution to the right hand side
F -= K[:, boundary] * u(m.points[boundary,1], m.points[boundary,2], m.points[boundary,3])
F[boundary] = u(m.points[boundary,1], m.points[boundary,2], m.points[boundary,3])

# suppress rows and columns from the K matrix
Ii,Ji,Vi=findnz(K)
In = Int64[]
Jn = Int64[]
Vn = Float64[]

for i = 1:size(Ii, 1)
    IIsNotBoundary = isempty(searchsorted(boundary, Ii[i]))
    JIsNotBoundary = isempty(searchsorted(boundary, Ji[i]))
    if IIsNotBoundary && JIsNotBoundary
        append!(In, Ii[i])
        append!(Jn, Ji[i])
        append!(Vn, Vi[i])
    end
end
append!(In, boundary)
append!(Jn, boundary)
append!(Vn, ones(size(boundary)))

Kn= sparse(In,Jn,Vn)
sol=Kn\F
norm(sol-u(m.points[:,1],m.points[:,2], m.points[:,3]))
