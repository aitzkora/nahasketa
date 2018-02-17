function buildPhilipsAandB(n)
    K = (s,x) -> if abs(s-x) ≤ 3 1+ cos((s-x)*π/3) else 0 end
    g = s -> (6 -abs(s))*(1+0.5*cos(π*s/3))+9/2π*sin(π*abs(s)/3)
    a=c=-6
    b=d=6
end

    
