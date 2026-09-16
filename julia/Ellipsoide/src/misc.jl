function newton1D(f, df, x₀::T, ITER_MAX::Int64 = 100, tol=1e-12) where {T}
  x = x₀ 
  it = 0
  while it < ITER_MAX 
    xn = x-f(x)/df(x)
    if abs(x-xn) < tol
      break
    end 
    x = xn
    it += 1
  end
  x, it
end 
