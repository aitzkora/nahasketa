mutable struct Mandel
  const WIN_DIM::Int64
  const MAX_ITERATIONS::UInt32
  leftX::Float32
  rightX::Float32
  topY::Float32
  bottomY::Float32
  xStep::Float32
  yStep::Float32
  Mandel(WIN_DIM, maxIt,leftX,rightX,topY,bottomY) = 
          new(WIN_DIM, maxIt, 
          leftX,
          rightX,
          bottomY,
          topY,
          (rightX - leftX) / WIN_DIM,
          (topY - bottomY) / WIN_DIM)
end

function zoom(m::Mandel, ZOOM_SPEED) 
    xRange = (m.rightX - m.leftX)
    yRange = (m.topY - m.bottomY)

    m.leftX   += ZOOM_SPEED * xRange
    m.rightX  -= ZOOM_SPEED * xRange
    m.topY    -= ZOOM_SPEED * yRange
    m.bottomY += ZOOM_SPEED * yRange

    m.xStep = (m.rightX - m.leftX) / m.WIN_DIM
    m.yStep = (m.topY - m.bottomY) / m.WIN_DIM
end


function it2col(iter::UInt32) 
  r = UInt32(0)
  g = UInt32(0)
  b = UInt32(0)
  if (iter < 0x00003F) 
    r = iter * 2
  elseif (iter < 0x00007F)
    r = (((iter - 0x000040) * 0x00050) ÷ 0x00007E) + 0x000080
  elseif (iter < 0x000100)
    r = (((iter - 0x000080) * 0x0003E) ÷ 0x00007F) + 0x0000C1
  elseif (iter < 0x000200) 
    r = 0x0000FF
    g = (((iter - 0x000100) * 0x0003E) ÷ 0x0000FF) + 0x000001
  elseif (iter <= 0x000400) 
    r = 0x0000FF
    g = (((iter - 0x000200) * 0x0003F) ÷ 0x0001FF) + 0x000040
  elseif (iter <=  0x000800) 
    r = 0x0000FF
    g = (((iter - 0x000400) * 0x0003F) ÷ 0x0003FF) + 0x000080 
  else 
    r = 0x0000FF
    g = (((iter -  0x000800) * 0x0003F) ÷  0x0007FF) +  0x0000C0
  end  
  return r << 0x000018| g << 0x000010 | b << 0x000008| 0x0000FF
end

function compute_buff(m::Mandel, X::Array{UInt32,2})
  for i=1:m.WIN_DIM
    for j=1:m.WIN_DIM
      c = Complex(m.leftX + m.xStep *j, m.topY - m.yStep * i)
      z = 0*1im
      flag = false
      iter = 0
      while !flag
        zp = z^2 + c
        flag = (abs2(z) > 4) || (iter >= m.MAX_ITERATIONS)
        z = zp
        iter += 1
      end
      X[i,j] = (iter >= m.MAX_ITERATIONS ? 0x0000FF : it2col(UInt32(iter)))
    end 
  end
end

 
function program()
 leftX     = -0.2395f0
 rightX    = -0.2275f0
 topY      =  0.660f0
 bottomY   =  0.648f0
 MAX_ITERATIONS = 1000
 WIN_DIM = 200
 OUTER_ITERATIONS = 100
 ZOOM_SPEED = -0.01
 m = Mandel(WIN_DIM, MAX_ITERATIONS, leftX, rightX, topY, bottomY)
 X = zeros(UInt32, WIN_DIM, WIN_DIM)
 for i=1:OUTER_ITERATIONS
   compute_buff(m, X)
   zoom(m, ZOOM_SPEED)
 end
end

program()
