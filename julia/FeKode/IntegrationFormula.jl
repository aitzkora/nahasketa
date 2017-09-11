"""
Implement the Gauss integation formulae

points::Array{Float64,2} reference Gauß points in the unit simplex
weights::Array{Float64} weights associated to the Gauß points

Formally we approx `` \int_T f(x) dx = \sum_k w_k f(ξ_k) ``
"""
type IntegrationFormula
   dim::Int8
   points::Array{Float64,2}
   weights::Array{Float64}
end

function IntegrationFormula(dim::Int64,order::Int64)
   if (dim==2)
      if (order == 2)
          weights = fill(1/6., 3);
          points = a = [[2/3. 1/6.]; [1/6. 1/6.]; [1/6. 2/3.]];
          return IntegrationFormula(2, points, weights)
      end
   end
end

function integrate(f, formula::IntegrationFormula)
    accu=f(tuple(formula.points[1,:]...)...)
    for i = 2 : size(formula.weights,1)
        accu += f(tuple(formula.points[i,:]...)...) * formula.weights[i];
    end
    return accu
end

using Base.Test
@test_approx_eq_eps integrate((x,y)->x*y,z) 1./24 1e-6
