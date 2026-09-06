# the true inverse
exact(x::T,a::T) where {T<:Real} = one(T)/(a+x)

# the rapid formula
function approx(x::T,a::T) where {T<:Real} 
  inv_a = one(T)/a 
  return inv_a - inv_a * x * inv_a
end

# compare the two value in the type
function compute_error(a::T) where {T<:Real}
  return abs(exact(eps(T)/2, a) - approx(eps(T)/2, a))
end

function test_type(::Type{T}) where {T<:Real}
  nb=12
  res=zeros(T, nb)
  a = one(T)
  for i=1:nb
    res[i] = compute_error(a)
    a /=10
  end
  res
end

using Printf
a64 = test_type(Float64)
a32 = test_type(Float32)

function print_hor(tab)
  @printf("|")
  for i=1:size(tab,1)
    @printf(" %.2e |", tab[i])
  end
  @printf("\n")
end
print_hor(10. .^[-(1:12);])
print_hor(a64)
print_hor(a32)
