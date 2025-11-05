"""
MyFloat is a datatype for representing (-1)ˢ m × 2ᵉ⁻ᵗ floats
"""
Base.@kwdef mutable struct MyFloat
  m::Vector{Bool}
  e::Int64  
  s::Bool
  t::Int64 = 3
  emin::Int64 = -1
  emax::Int64 = 3
end

"""
add two Bool vector with carry
"""
function add_mantissa(x::Vector{Bool}, y :: Vector{Bool})
    @assert length(x) == length(y)
    n = length(x)
    z = fill(false, n)
    for i=n:-1:2
      tmp = z[i] + x[i] + y[i]
      if (tmp >= 2)
          z[i-1] = 1
          z[i] = tmp - 2
      else
          z[i] = tmp
      end
    end
    tmp = x[1] + y[1]
    if (tmp>= 2)
        @error "overflow"
    else
        z[1] = tmp
    end
    return z
end

using LinearAlgebra
function eoshift(x::Vector{Bool}, shf::Int64 = 0)
    Bool[Bool.(diagm(shf=> ones(length(x)-abs(shf)))*x)...]
end


function plus(x::MyFloat, y:: MyFloat)
    @assert (x.t == y.t) && (x.emin == y.emin) &&  (x.emax == y.emax) && 
            (x.s == y.s)
    @assert x.s == false
    if (y.e > x.e)
      return plus(y, x)
    end
    m_y_shf = eoshift(y.m, x.e-y.e)
    m_add = add_mantissa( x.m, m_y_shf)
    return MyFloat(m_add, x.e, x.s, x.t, x.emin, y.emin)
end    

function MyFloat(x::Float64, t::Int64 = 3, emin::Int64 = -1, emax::Int64 =3)
    @assert x >= 0
    e = Int64(floor(log2(x))) + 1
    k = Int(floor(abs(x)/exp2(e-t)))
    m = Bool[digits(k; base=2, pad=t)...]
    m = m[end:-1:1]
    MyFloat(m, e, false, t, emin, emax)
end

function str_to_exp(x::Int64) 
    exps = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]
    dic = Dict([string.([0:9;]) .=>  exps; "-" =>"⁻"])
    reduce(*,(x->dic[x]).([string(c) for c in string(x)]))
end

function Base.show(io::IO, z::MyFloat) 
  str_2 = "("*reduce(*,map(x->string((x ? 1 : 0)),z.m))*")₂"
  str_2 *= "×2"*str_to_exp(z.e-z.t)
  print(io, str_2 * " => ", (exp2.([z.t-1:-1:0;])'*z.m)*exp2(z.e-z.t))
end

z2 = MyFloat(Bool[0,1,0], 2, false, 3, -1, 3)
z = MyFloat(Bool[1,0,0], 2, false, 3, -1, 3)


