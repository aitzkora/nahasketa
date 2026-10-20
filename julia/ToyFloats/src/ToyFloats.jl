module ToyFloats


export ToyFloat

"""
ToyFloat is a datatype for representing (-1)ˢ m × βᵉ⁻ᵗ floats
"""
struct ToyFloat{BETA, T, EMIN, EMAX}
  m::SVector{T,Bool} # mantissa
  e::Int64  # exponent
  s::Bool # sign
  function ToyFloat{BETA, T, EMIN, EMAX}(m::SVector{T, Bool}, e::Int64, s::Bool; ) where {BETA,T, EMIN, EMAX}
    @assert T isa Integer
    @assert EMIN isa Integer
    @assert EMAX isa Integer
    if (m[1]==0) 
       @warn "m is denormalized mantissa"
    end
    return new{T, EMIN, EMAX}(m, e, s)
  end
end



end # module ToyFloats
