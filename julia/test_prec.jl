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
    if (m[1]==0) 
       @warn "m is denormalized mantissa"
    end
    return new{T, EMIN, EMAX}(m, e, s)
  end
end

"""
outer constructor taking Vector of Bool
"""
function MyFloat{T, EMIN, EMAX}(m::Vector{Bool}, e::Int64, s::Bool) where {T, EMIN, EMAX}
    return MyFloat{T, EMIN, EMAX}(SVector{T,Bool}(m...), e, s)
end

function str2bool(hoho::String)
  map(x->Dict(['0', '1'] .=> [false, true])[x],collect(hoho))
end

"""
constructor from string
"""
function MyFloat{T, EMIN, EMAX}(s::String, e::Int64, sgn::Bool) where {T, EMIN, EMAX}
  @assert length(s) == T
  @assert all((x -> x in ['0','1']).(collect(s)))
  MyFloat{T, EMIN, EMAX}(SVector{T,Bool}(str2bool(s)), e, sgn)
end



function emin(::Type{<:MyFloat{T, EMIN,  EMAX}}) where {T, EMIN, EMAX}
   return EMIN
end

function emax(::Type{MyFloat{T, EMIN,  EMAX}}) where {T, EMIN, EMAX}
   return EMAX
end

function precision(::Type{<:MyFloat{T, EMIN,  EMAX}}) where {T, EMIN, EMAX}
   return T
end


"""
add two SVector{T,Bool} with carry
"""
function add_mantissa(x::SVector{T,Bool}, y::SVector{T,Bool}) where {T}
    z = fill(false, T)
    for i=T:-1:2
      tmp = z[i] + x[i] + y[i]
      if (tmp >= 2)
         #if (i == 1) 
         #    throw(OverflowError("mantissa is to small"))
         #end
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
    return SVector{T, Bool}(z)
end

## test mantissa functions
using Test 

@testset "add mantissa" begin

 s1 = SVector{3, Bool}(0, 1, 0)
 s2 = SVector{3, Bool}(1, 0, 1)
 s3 = SVector{3, Bool}(1, 1, 1)

 #@test add_mantissa(s1, s2) == s3
 #@test_throws OverflowError add_mantissa(s1, s3)
end

function Base.:<<(x::SVector{T,Bool}, shf::Int64 = 0) where T
  if (shf >= 0) && (shf <= T)
      return vcat(SVector{T-shf,Bool}(x[shf+1:end]), SVector{shf, Bool}(zeros(shf)))
  else
      throw(DomainError("shf = $shf ̸∈ [0,$T]"))
  end
end

# addition
function Base.:+(x::MyFloat{T,EMIN, EMAX}, y:: MyFloat{T,EMIN, EMAX}) where {T, EMIN, EMAX}
    @assert (x.s == false) && (x.s == y.s)
    if (y.e > x.e)
      return Base.:+(y, x)
    end
    shf = x.e-y.e
    expo = x.e
    if (shf > T)
        return MyFloat{T, EMIN, EMAX}(x.m, expo, x.s) 
    end
    m_add = add_mantissa( x.m, y.m << shf)
    return MyFloat{T, EMIN, EMAX}(m_add, expo, x.s)
end    

# cast Julia's float to MyFloat
function MyFloat{T, EMIN, EMAX}(x::F) where {T,EMIN, EMAX, F <: AbstractFloat}
    @assert x >= 0
    e = Int64(floor(log2(x))) + 1
    k = Int(ceil(abs(x)/exp2(e-T)))
    m = Bool[digits(k; base=2, pad=T)[end:-1:1]...]
    m = m[end:-1:1]
    MyFloat{T, EMIN, EMAX}(SVector{T,Bool}(m), e, false)
end

# print functions

function exp_string(x::Int64) 
    exps = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]
    dic = Dict([string.([0:9;]) .=>  exps; "-" =>"⁻"])
    reduce(*, (x->dic[x]).([string(c) for c in string(x)]))
end

function Base.show(io::IO, z::MyFloat{T, EMIN, EMAX}) where {T, EMIN, EMAX}
  str_2 = "("*reduce(*,map(x->string((x ? 1 : 0)),z.m))*")₂"
  str_2 *= "×2"*exp_string(z.e-T)
  print(io, "[" * str_2 * ", " * string(exp2.([T-1:-1:0;])'*z.m*exp2(z.e-T)) * "]")
end

# Some constants
"""
the Nick Higham's Book small float type
"""
const FloatNH = MyFloat{3, -1, 3}

z1 = FloatNH(Bool[1,0,1], -1, false)
z2 = FloatNH(Bool[1,0,0], -2, false)
#z3 = FloatNH(2.0)

println(z1 , " + ", z1, " -> ", z1 + z1 )

const MyFloat16 = MyFloat{11, -14, 15}

function enumerate(::Type{<:MyFloat{T, EMIN, EMAX}}) where {T, EMIN, EMAX}
    estimation = (1<<T) * (EMAX-EMIN)
    if (estimation > 100)
        return   estimation
    else
       return [ MyFloat{T,EMIN,EMAX}(Bool[digits(m; base=2, pad=T)[end:-1:1]...],e, false) for e=EMIN:EMAX for m=1<<(T-1):(1<<T-1)]
    end
end 

