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
    IntegrationFormula(dim::Int64, order::Int64)=
    begin
        if (dim == 0)
            return new(0, [[0];]', [1.])
        elseif dim == 1 && order in 2:3
            return new(1, [[(-sqrt(1/3.) + 1.0) / 2 (sqrt(1/3.) + 1.0) / 2];], [0.5, 0.5])
        elseif (dim,order) == (2,2)
            return new(2, [[2/3. 1/6.]; [1/6. 1/6.]; [1/6. 2/3.]]', fill(1/6., 3))
        elseif (dim,order) == (2,3)
            begin inverse_tan = atan(0.75);
                cos_third = cos(inverse_tan/3.0);
                sin_third = sin(inverse_tan/3.0);
                a = sin_third/(2*sqrt(3.0)) - cos_third/6.0 + 1.0/3.0;
                b = - sin_third/(2*sqrt(3.0)) - cos_third/6.0 + 1.0/3.0;
                c = cos_third/3.0 + 1.0/3.0;
                return  new(2, [[a b]; [a c]; [b a]; [b c]; [c a]; [c b] ]', fill(1/12., 6))
            end
        elseif (dim, order) == (3, 2)
            begin
                sqrtFifth = 1.0 / sqrt(5.0);
                a = (1.0 + 3.0 * sqrtFifth) / 4.0;
                b = (1.0 - sqrtFifth) / 4.0;
                return new(3,[[a b b]; [b a b]; [b b a]; [b b b]]' , fill(1/24., 4))
            end
        elseif (dim, order) == (3, 3)
            begin rootSeventeen = sqrt(17.0);
                rootTerm = sqrt(1022.0 - 134.0 * rootSeventeen);
                b = (55.0 - 3.0*rootSeventeen + rootTerm) / 196;
                d = (55.0 - 3.0*rootSeventeen - rootTerm) / 196;
                a = 1.0 - 3.0 * b;
                c = 1.0 - 3.0 * d;
                w1 = (20.0*d*d - 10.0*d + 1.0)/(240.0*(2.0*d*d - d - 2.0*b*b + b));
                w2 = 1.0/24.0 - w1;
                return new(3,
                [[a b b]; [b a b]; [b b a]; [b b b]; [c d d]; [d c d]; [d d c]; [d d d]]',
                [fill(w1, 4); fill(w2, 4)])
            end
        else
            error("IntegrationFormula: no existing integration formula for these arguments")
        end
    end
end

"""
integrate function f on the unit simplex using gauß formula
"""
function integrate(f, form::IntegrationFormula)
    @assert size(form.points, 2) ==  size(form.weights,1) "integrate :  points and weights do no have compatible dimensions"
    return (mapslices(f, form.points, 1)*form.weights)[1]
end


