mutable struct Mandel
  const WIN_DIM::Int64
  const MAX_ITERATIONS::Int64
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
          (rightX - leftX) / WIN_DIM
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


function it2color(iter) 
  r = Uint32(0)
  g = Uint32(0)
  b = Uint32(0)
  if (iter < 63) 
    r = iter * 2
  else if (iter < 127)
    r = (((iter - 64) * 128) / 126) + 128
  else if (iter < 256)
    r = (((iter - 128) * 62) / 127) + 193
  else if (iter < 512) 
    r = 255
    g = (((iter - 256) * 62) / 255) + 1
  else if (iter <= 1024) 
    r = 255
    g = (((iter - 512) * 63) / 511) + 64
  else if (iter <= 2048) 
    r = 255
    g = (((iter - 1024) * 63) / 1023) + 128 
  else 
    r = 255
    g = (((iter - 2048) * 63) / 2047) + 192
  end  
  return r << 24 | g << 16 | b << 8| 255
end

function compute_buff(mandel, X::Array{Int8,2})
  for i=1:mandel.winDim
    for j=1:mandel.winDim
      c = Complex(leftX + m.xStep *j, topY - yStep * i)
      z = 0*1im
      for iter = 0, MAX_ITERATIONS
        zp = z^2 + c
        if (abs2(z) > 4) 
          break
        end
        z = zp
      end
      X[i,j] = (iter == MAX_ITERATIONS ? 255 : it2col(iter))
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
 m  =  Mandel(WIN_DIM, MAX_ITERATIONS, leftX, rightX, topY, bottomY)
 X = zeros(UInt8, WIN_DIM, WIN_DIM)
 for i=1:OUTER_ITERATIONS
   compute_bufft(mandel, X)
   zoom(mandel, ZOOM_SPEED);
 end
end

