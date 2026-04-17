using FFTW
using GLMakie
using DSP
sample_rate = 1e6

#img1 = mapslices(x->RGBAf(x...),m_norm; dims=(3))[:,:,1]

# Générer une tonalité plus un bruit
t = [0:1024*1000;]./sample_rate # vecteur de temps
f = 50e3 # fréquence de la tonalité
x = sin.(2π*f*t) .+ 0.2 .* randn(size(t,1))


function fft_window(x, offset;  width = 1024)
  s = x[offset:offset+width-1] .* hamming(width)
  S = fftshift(fft(s))
  mag = 10*log10.(abs.(S).^2)
end 

height_size = 200
win_size = 256
fig = Figure(backgroundcolor = RGBf(([238, 130, 255] /255)...), size = (height_size, win_size))

nb_win = size(x,1) ÷ win_size

z=zeros(nb_win, win_size)

for i=1:nb_win
  z[i,:] = fft_window(x, i; width=win_size)
end  

nb_trames = nb_win ÷ height_size
GLMakie.heatmap(fig[1,1], z[1:height_size,:]' , axis=(title="Waterfall", ))

for tr=2:nb_trames-1
  GLMakie.heatmap!(fig[1,1], z[1+tr*height_size:(tr+1)*height_size,:]')
  sleep(0.001) 
end


