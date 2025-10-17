using Plots 
using LaTeXStrings
function sine_wave(freq, ofs, ψ, nbCycles)
  fs = ofs * freq
  t = LinRange(0., 1. *nbCycles/freq-1/fs, Int64(fs))
  t, sin.(2π*freq*t.+ψ)
end

"""
Simulate a sinusoidal signal wave with given sampling rate
"""
function sine_wave_demo()
  f= 10. #Hz
  ofs = 30
  ψ = π/3.
  nCycles = 5
  t, g = sine_wave(f, ofs, ψ, nCycles)
  Plots.plot(t,g)
  Plots.title!("Sin Wave f = $f Hz")
  Plots.xlabel!("Time (s)")
  Plots.ylabel!("Amplitude")
end


using FFTW 
function fft_demo()
  fc=10
  fs=32*fc
  t=collect(0.:1. /fs:2.)[1:end-1]
  x=cos.(2π*fc*t)
  N=256
  X=fft(x[1:N],1)

  df = fs/N
  sampleIdx = collect(0:N-1)
  f=sampleIdx*df

  plot(layout=grid(2,1))
  plot!(t, x, title=L"x[n] = cos (2 \pi 10 t)", sp=1, xlabel=L"t=nT_s", ylabel=L"x[n]", legend=false)
  plot!(sampleIdx, abs.(X), title=L"X[f]", sp=2, xlabel=L"f \in [0,255]", ylabel=L"|X[f]|", legend=false)
  myshow()

end

