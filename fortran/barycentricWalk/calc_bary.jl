using LinearAlgebra
function calc_bary(x, x0)

  a = x[1,1] - x[1,3] 
  b = x[1,2] - x[1,3]
  c = x[2,1] - x[2,3]
  d = x[2,2] - x[2,3]
  denom = a * d - b * c

  if (abs(denom)/norm(x,2) < 1e-10)
     writeln("pb in compute_barycenters")
  end
  rhs = x0 - x[:, 3]
  theta = zeros(3)
  theta[1] = (rhs[1] * d - rhs[2] * b) / denom
  theta[2] = (rhs[2] * a - rhs[1] * c) / denom
  theta[3] = 1.0 - theta[1] - theta[2]
  return theta
end

function bary2(x, x0)
 theta = (x[:,1:2]-(x[:,[3,3]]))\(x0-x[:,3])
 theta = [theta; 1.0 - sum(theta)]
end

function patho_x(epsi = 1e-13)
   x = rand(2,2)
   v3 = epsi*(x[:,2]-x[:,1])
   x = [ x[:,1] v3+x[:,1] v3 ]
end

