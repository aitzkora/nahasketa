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
g2 = fig[2,1] = GridLayout()
ax2 = Axis(fig[2,1], title="S_phase")
lines!(ax2, f, S_phase)



