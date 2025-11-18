using StaticArrays

"""
MyFloat is a datatype for representing (-1)ˢ m × 2ᵉ⁻ᵗ floats
"""
struct MyFloat{T, EMIN, EMAX}
  m::SVector{T,Bool}
  e::Int64  
  s::Bool
  function MyFloat{T, EMIN, EMAX}(m::SVector{T, Bool}, e::Int64, s::Bool) where {T, EMIN, EMAX}
    @assert T isa Integer
    @assert EMIN isa Integer
    @assert EMAX isa Integer
    return new{T, EMIN, EMAX}(m, e, s)
  end
end

"""
add two SVector{T,Bool} with carry
"""
function add_mantissa(x::SVector{T,Bool}, y::SVector{T,Bool}) where {T}
    z = fill(false, T)
    for i=T:-1:2
      tmp = z[i] + x[i] + y[i]
      if (tmp >= 2)
          z[i-1] = 1
          z[i] = tmp - 2
      else
          z[i] = tmp
      end
    end
    tmp = x[1] + y[1] + z[1]
    if (tmp>= 2)
        throw(OverflowError("mantissa is to small"))
    else
        z[1] = tmp
    end
    return SVector{T, Bool}(z)
end

## test mantissa functions
using Test 

@testset "add mantissa" begin

 s1 = SVector{3, Bool}(0, 1, 0)
 s2 = SVector{3, Bool}(1, 0, 1)
 s3 = SVector{3, Bool}(1, 1, 1)

 @test add_mantissa(s1, s2) == s3

 @test_throws OverflowError add_mantissa(s1, s3)

end

using LinearAlgebra

function eoshift(x::SVector{T,Bool}, shf::Int64 = 0) where T
  if (shf >= 0)
      return vcat(SVector{T-shf,Bool}(x[shf+1:end]), SVector{shf, Bool}(zeros(shf)))
  else
      throw(DomainError("shf must be positive"))
  end
end

function Base.:<<(x::SVector{T,Bool}, shf::Int64 = 0) where T
  return eoshift(x, shf)
end

function plus(x::MyFloat{T,EMIN, EMAX}, y:: MyFloat{T,EMIN, EMAX}) where {T, EMIN, EMAX}
    @assert (x.s == false) && (x.s == y.s)
    if (y.e > x.e)
      return plus(y, x)
    end
    shf = x.e-y.e
    expo = x.e
    if (shf > T + 2)
        return MyFloat{T, EMIN, EMAX}(x.m, expo, x.s) 
    end
    m_add = add_mantissa( x.m, y.m << shf)
    return MyFloat{T, EMIN, EMAX}(m_add, expo, x.s)
end    

function MyFloat{T, EMIN, EMAX}(x::Float64) where {T,EMIN, EMAX}
    @assert x >= 0
    e = Int64(floor(log2(x))) + 1
    k = Int(floor(abs(x)/exp2(e-t)))
    m = Bool[digits(k; base=2, pad=t)...]
    m = m[end:-1:1]
    MyFloat{T, EMIN, EMAX}(m, e, false)
end

function str_to_exp(x::Int64) 
    exps = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]
    dic = Dict([string.([0:9;]) .=>  exps; "-" =>"⁻"])
    reduce(*,(x->dic[x]).([string(c) for c in string(x)]))
end

function Base.show(io::IO, z::MyFloat{T, EMIN, EMAX}) where {T, EMIN, EMAX}
  str_2 = "("*reduce(*,map(x->string((x ? 1 : 0)),z.m))*")₂"
  str_2 *= "×2"*str_to_exp(z.e-T)
  print(io, "[" * str_2 * ", " * string(exp2.([T-1:-1:0;])'*z.m*exp2(z.e-T)) * "]")
end


function Base.:+(x::MyFloat{T, EMIN, EMAX}, y::MyFloat{T, EMIN, EMAX}) where {T,EMIN, EMAX}
    return plus(x, y)
end


"""
the Nick Higham's Book small float type 
t = 3
emin = -1
emax = 3
"""
const FloatNH = MyFloat{3, -1, 3}


z2 = MyFloat{3, -1, 3}(Bool[0,1,0], 3, false)
z1 = MyFloat{3, -1, 3}(Bool[1,0,0], 2, false)

println(z1 , " + ", z2, " -> ", z1 + z2 )
