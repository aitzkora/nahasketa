using Plots
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
