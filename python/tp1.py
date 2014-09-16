from numpy import *
from matplotlib import pyplot as plt
from numpy.linalg import solve
def K1D(n):
     return -diag(ones(n-1), -1) + 2 * eye(n) -diag(ones(n-1),1)
def K2D(n):
    return kron(eye(n),K1D(n))+kron(K1D(n),eye(n))

N = 30
b = ones(N);
b[0] = 1
b[-1] = -1
h = 1./N
x = solve(K1D(N)/h**2,b)
#plt.plot(mgrid[0:x.shape[0]],x)
#plt.show()

B = ones((N,N))
#B[1:-1,1:-1] = 0
X = solve(K2D(N)/(2*h**2),B.flatten())
X.shape = N,N
from mpl_toolkits.mplot3d import Axes3D
fig2 = plt.figure()
ax = Axes3D(fig2)
XX,YY = mgrid[0:1:N*1.j,0:1:N*1.j]
ax.plot_surface(XX,YY, X, rstride = 2, cstride = 2, cmap= plt.cm.coolwarm)
#ax.set_zlim(X.min(), X.max())
plt.show()



