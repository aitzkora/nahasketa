using Printf
using PyPlot
function meshGrid(x,y)
    xx = repeat(x, outer=length(y))
    yy = repeat(y, inner=length(x))
    XX = reshape(xx, length(x), length(y))
    YY = reshape(yy, length(x), length(y))
    return XX,YY
end
function heatPlot(sol)
    N = size(sol, 3)
    x=LinRange(0,1, size(sol, 1))
    y=LinRange(0,1, size(sol, 2))
    XX, YY = meshGrid(x,y)
    fig = figure()
    surf(XX,YY,sol[:, :, 1])
    ax = Axes3D(fig)
    ax[:set_zlim3d](bottom=0., top=1.)
    for i=2:N
        ax[:clear]()
        surf(XX, YY, sol[:,:,i])
        ax[:set_zlim3d](bottom=0., top=1.)
        savefig(@sprintf("zutos_%04d", i))
    end
    #run(`ffmpeg -loop_output 0 zutos_%04d.png heat.avi`)
end
