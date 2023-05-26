# fonction de substitution arriere pour un cholesky O(n^2)
function back_sub(R::Array{Float64,2},w::Array{Float64})
  n=size(w,1)
  x=zeros(n)
  x[n]=w[n]/R[n,n]
  for i=(n-1):-1:1
    x[i]=(w[i]-R[i,i+1:n] ⋅ x[i+1:n]) / R[i,i]
  end
  return x
end

# fonction de substitution avant pour un cholesky O(n^2)
function for_sub(R,g)
  n=size(g, 1)
  w=zeros(n)
  w[1]=g[1]/R[1,1]
  for i=2:n
    w[i]=(g[i]-R[1:i-1,i] ⋅ w[1:i-1]) / R[i,i]
  end
  return w
end
function for_sub2(R,g)
  n=size(g, 1)
  w=zeros(n)
  w[1]=g[1]/R[1,1]
  for i=2:n
    w[i]=(g[i]-R[i,1:i-1] ⋅ w[1:i-1]) / R[i,i]
  end
  return w
end
# fonction de calcul de l'inverse d'un cholesky 
function inv_chol(L) 
  n=size(L,1)
  R=zeros(n,n)
  for j=n:-1:1
	R[j,j]=1. / L[j,j]
	for i=j-1:-1:1
	  R[i,j]=-L[i,i+1:j] ⋅ R[i+1:j,j] / L[i,i]
	end
  end
  return R 
end
function fft_apply2(A::Array{Float64,2})

  n = size(A,1)
  @assert size(A,2) == n
  tmp = zeros(ComplexF64, n , n)

  H = zeros(ComplexF64, n , n)
  for j=1:n
     tmp[:,j] = fft(A[:,j])
  end
  @info tmp 
  for j=1:n
     H[j,:] = fft(tmp[j,:])
  end
  return H
end


function ⨶(x,y)
  n = size(x,1)
  @assert size(y, 1) == n
  N = Base.nextprod((2,), 2 * n + 1)
  X = fft([x; zeros(N-n)])
  Y = fft([y; zeros(N-n)])
  return real(ifft(conj(X) .* Y ))[1:n]
end

using Test

function acy(x,y)
  n=size(x,1)
  @assert size(y,1) == n
  z = zeros(n)
  for k=0:n-1
     z[k+1] = x[1:n-k] ⋅ y[k+1:n]
  end
  return z
end
function calc_diffs_old(x::Array{Float64},prec::Float64 = 1e-6)
n = size(x, 1)
r = cholesky(𝓑(-x))
tmp=r.U \ Matrix(I, n, n)
N=Base.nextprod((2,), 2*n+1)
r=zeros(N,n)
r[1:n,:]=tmp
accu1=zeros(ComplexF64, N, N)
accu2=zeros(ComplexF64, N, N)
accu3=zeros(ComplexF64, N)
for j=1:n
  R=fft(r[:,j])
  accu1 += R*R'
  accu2 += R*conj(R')
  accu3 += R .* conj(R) # for the gradient
end
accu1=accu1.*conj(accu1)+accu2.*conj(accu2)
# defourierisons une premiere fois suivant les colonnes...
H=zeros(n,n)
tmp2 = zeros(ComplexF64,N,N)
for j=1:N
  tmp2[:,j]=ifft(accu1[:,j])
end
# puis une seconde sur les lignes...
for j=1:n
  tmp=ifft(tmp2[j,:])
  H(j,:)=2*real(tmp[1:n])
end
#H=(abs.(H) .>= prec) .* H
g=2*ifft(accu3)
g=real(g[1:n])
#g=(abs.(g) .>= prec) .* g
end

