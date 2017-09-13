"""
Implement the Gauss integation formulae

- points::Array{Float64,2} reference Gauß points in the unit simplex
- weights::Array{Float64} weights associated to the Gauß points

Formally we approx `` \\int_T f(x) dx = \\sum_k w_k f(ξ_k) ``
"""
type IntegrationFormula
   dim::Int8
   points::Array{Float64,2}
   weights::Array{Float64}
end


using Match
function IntegrationFormula(dim::Int64, order::Int64)
     @match (dim, order) begin
         (0,_) => IntegrationFormula(0, [[0]], fill(1.,1))
         (1, 2||3) => IntegrationFormula(1, [[(-sqrt(1/3.) + 1.0) / 2 (sqrt(1/3.) + 1.0) / 2]], [0.5, 0.5])
         (2,2) => IntegrationFormula(2, [[2/3. 1/6.]; [1/6. 1/6.]; [1/6. 2/3.]]', fill(1/6., 3))
         (2,3) => begin inverse_tan = atan(0.75);
                     cos_third = cos(inverse_tan/3.0);
                     sin_third = sin(inverse_tan/3.0);
                     a = sin_third/(2*sqrt(3.0)) - cos_third/6.0 + 1.0/3.0;
                     b = - sin_third/(2*sqrt(3.0)) - cos_third/6.0 + 1.0/3.0;
                     c = cos_third/3.0 + 1.0/3.0;
                     IntegrationFormula(2, [[a b]; [a c]; [b a]; [b c]; [c a]; [c b] ]', fill(1/12., 6))
                  end
         (3, 2) => begin sqrtFifth = 1.0 / sqrt(5.0);
                      a = (1.0 + 3.0 * sqrtFifth) / 4.0;
                      b = (1.0 - sqrtFifth) / 4.0;
                      IntegrationFormula(3,[[a b b]; [b a b]; [b b a]; [b b b]]' , fill(1/24., 4))
                  end
         (3, 3) => begin rootSeventeen = sqrt(17.0);
                      rootTerm = sqrt(1022.0 - 134.0 * rootSeventeen);
                      b = (55.0 - 3.0*rootSeventeen + rootTerm) / 196;
                      d = (55.0 - 3.0*rootSeventeen - rootTerm) / 196;
                      a = 1.0 - 3.0 * b;
                      c = 1.0 - 3.0 * d;
                      w1 = (20.0*d*d - 10.0*d + 1.0)/(240.0*(2.0*d*d - d - 2.0*b*b + b));
                      w2 = 1.0/24.0 - w1;
                      IntegrationFormula(3,
                                         [[a b b]; [b a b]; [b b a]; [b b b]; [c d d]; [d c d]; [d d c]; [d d d]]',
                                         [fill(w1, 4); fill(w2, 4)])
                   end
        (_, _) => IntegrationFormula(-1, Float64[], Float64[])
     end
end


"""
integrate function f on the unit simplex using gauß formula
"""
function integrate(f, form::IntegrationFormula)
    @assert size(form.points, 2) ==  size(form.weights,1) "integrate :  points and weights do no have compatible dimensions"
    return mapslices(f, form.points, 1)*form.weights
end

using Base.Test
@test_approx_eq_eps integrate(prod,IntegrationFormula(2,2)) 1./24 1e-12 # integrate(x*y,(y,0,1-x),(x,0,1))
@test_approx_eq_eps integrate(x->x[1]^2*x[2], IntegrationFormula(2,3)) 1/60. 1e-12 #integrate(x*x*y,(y,0,1-x),(x,0,1))
@test_approx_eq_eps integrate(x->x[1]*x[2],IntegrationFormula(3,2)) 1/120. 1e-12 #integrate(x*y,(z,0,1-y-x),(y,0,1-x),(x,0,1))
@test_approx_eq_eps integrate(prod,IntegrationFormula(3,3)) 1/720. 1e-12 # integrate(x*y*z,(z,0,1-y-x),(y,0,1-x),(x,0,1))
