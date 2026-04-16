using FFTW
sample_rate = 1e6

Fs = 1 # Hz
N = 100 # le nombre de points à simuler, et la taille de notre FFT

t = [1:N;] # parce que notre taux d'échantillonnage est de 1 Hz 
s = sin.(0.15*2*π*t)  # Our signal                                         
S = fftshift(fft(s))
S_mag = abs.(S)
S_phase =angle.(S)                                                 
f = range(Fs/-2, Fs/2-Fs/N, step=Fs/N) # like arange(-Fs/2,Fs/2,Fs/N)

using GLMakie
fig = Figure(backgroundcolor = RGBf(([238, 130, 255] /255)...), size = (320, 240))
g1 = fig[1,1] = GridLayout()
ax1 = Axis(fig[1,1], title = "S_mag" )
lines!(ax1, f, S_mag)
g2 = fig[1,2] = GridLayout()
ax2 = Axis(fig[1,2], title="S_phase")
lines!(ax2, f, S_phase)

# Générer une tonalité plus un bruit
t = [0:1024*1000;]./sample_rate # vecteur de temps
f = 50e3 # fréquence de la tonalité
x = sin.(2π*f*t) .+ 0.2 .* randn(size(t,1))

using FFTW

function fft_window(x, offset;  width = 1024)
  s = x[offset:offset+width-1] * hamming(width)
  S = fftshift(fft(s))
end 

function spctgrm(x; width = 1024, height = 100)
  n_tram = size(t,1) ÷ width
  z=zeros(width,height)
  for i=1:ntrame
    z(:, ) = fft_window(x, i)
  end  
end
