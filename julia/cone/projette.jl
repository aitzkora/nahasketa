using FFTW
using LinearAlgebra
using Printf

# operateur dual
function 𝓑(z::Array{Float64})
  n = size(z,1)
  B = zeros(n,n)
  view(B, diagind(B)) .= 2 * z[1]
  for i=1:n-1
    view(B, diagind(B, i)) .= z[i+1]
    view(B, diagind(B,-i)) .= z[i+1]
  end 
  return B
end

function ∂ₓH_and_g(x::Array{Float64},prec::Float64 = 1e-6)
  n = size(x, 1)
  N=Base.nextprod((2,), 2*n+1)
  r = cholesky(𝓑(-x))
  r=[r.U \ Matrix(I, n, n); zeros(N-n, n)]
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
  # 2D inverse fft
  H=2*real(ifft(accu1))[1:n,1:n]
  H[abs.(H).<prec] .= 0.
  g=real(2*ifft(accu3))[1:n]
  g[abs.(g).<prec] .= 0.
  return (H,g)
end

# algorithme de résolution d'un problème de projection 
# calcul minₓ   ||x-r||²  
#               x ∈ 𝓒ᵒ
# μ ← facteur d'augmentation du paramètre de la barrière
# ε ← precision souhaite pour le test d'arret
function projette_polaire(x0::Array{Float64},μ::Float64=2.,ε::Float64=1e-3)
  n=size(x0, 1)
  x=[-0.5; zeros(n-1,1)]
  y=n * 1.0

  # boucle generale exterieure, on trace le chemin central en
  # fonction de t
  # valeur initiale de t
  t=1.0
  flag=false
  out_loop=0
  @printf " Out.|     t         | In. |   <x0-x,x>     |\n"
  @printf "---------------------------------------------\n"
  while(~flag)
    #Boucle de Newton
    flag_new=false
    in_loop=0
    while(~flag_new)
      (H2, g2) =∂ₓH_and_g(x, ε)
      # Hessien de Lₙ₊₂
      den = 1/(y^2 - sum((x-x0).^2))
      g1x   = 2*(x-x0) * den
      g1y   = -2*y*den
      dyg1x = -4*y*(x-x0) * den^2
      H1xx =4*den*den*(x-x0)*(x-x0)'+ diagm(ones(n)*2*den)
      d2g1y =4*(den*y)^2-2*den
      # on calcul le decrement de Newton 
      # a l'aide d'un facteur cholesky 
      g = [g1x+g2; t+g1y] 
      R = cholesky(Hermitian([H1xx+H2 dyg1x; dyg1x' d2g1y]))
      w = - R.L \ g
      flag_new=(w⋅w<=ε)
      d_xy = R.U \ w
      #On fait le pas de Newton
      pas = 1. /(1. + norm(w))
      x += pas * d_xy[1:n]
      y += pas * d_xy[n+1]
      in_loop += 1
    end    
    out_loop += 1
    @printf " %3d | %e  | %3d | %e  |\n" out_loop t in_loop (x0-x) ⋅ x
    # (\theta_1 + \theta_2)/t <ε
    flag=(( n + 2)/ t < ε)
    # on met à jour t
    t *= μ
  end
  sol=x
end

