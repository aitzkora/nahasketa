using LinearAlgebra
using N2QN1_jll
using Libdl:dlopen, dlsym
using Test
using Printf

function init_qnb()
   global n2qn1_ptr, qnb_ptr

   n2qn1_lib = dlopen(libn2qn1)
   n2qn1_ptr = dlsym(n2qn1_lib, :n2qn1_)

   qnb_lib = dlopen("./qnb.so")
   qnb_ptr = dlsym(qnb_lib, :n2qn1_)
end


function call_qnb!(x::Vector{Float64},
                   f::Float64,
                   g::Vector{Float64},
                   dxmin::Vector{Float64},
                   df1::Float64,
                   epsabs::Vector{Float64},
                   imp::Int64,
                   io::Int64,
                   mode::Vector{Cint},
                   iter::Int64,
                   nsim::Int64,
                   binf::Vector{Float64},
                   bsup::Vector{Float64},
                   iz::Vector{Cint},
                   rz::Vector{Float64},
                   reverse::Bool)
    @assert length(x) == length(g) == length(bsup) == length(binf)
    n = length(x)
    ccall(qnb_ptr, Cvoid, (Ref{Cint},    # n
                           Ref{Float64}, # x(1:n)
                           Ref{Float64}, # f
                           Ref{Float64}, # g
                           Ptr{Float64}, # dxmin
                           Ref{Float64}, # df1
                           Ptr{Float64}, # epsabs
                           Ref{Cint},    # imp
                           Ref{Cint},    # io
                           Ptr{Cint},    # mode
                           Ref{Cint},    # iter
                           Ref{Cint},    # nsim
                           Ptr{Float64}, # binf
                           Ptr{Float64}, # bsup
                           Ptr{Cint},    # iz
                           Ptr{Float64}, # rz
                           Ref{Cint}), # reverse
                           n,
                           x, 
                           f,
                           g,
                           dxmin,
                           df1,
                           epsabs,
                           imp,
                           io,
                           mode,
                           iter,
                           nsim,
                           binf,
                           bsup,
                           iz,
                           rz,
                           reverse) 
end




function bfgsb_reverse(f,g!, x0::Vector{Float64}, 
                      lb::Vector{Float64}, 
                      ub::Vector{Float64};
                      dxmin::Vector{Float64}=1e-12*ones(size(x0,1)),
                      print_iter::Bool=false,
                      max_iter::Int64=300)
  # allocate 
  xk = copy(x0)
  gk = zeros(length(x0))
  # init parameters
  df1 = f(x0)
  mode = ones(Cint, 1)
  imp = 0
  it = 0
  iter =  100
  nsim=3*iter
  iz = zeros(Cint, 1024) # why 1024
  rz = zeros(Float64, 1024)
  io = 06  # descripteur de fichier du journal 06-> std output
  fk=df1
  g!(gk,x0)
  epsabs = 5e-5*ones(1)*norm(gk)
  call_qnb!(xk, fk, gk, dxmin, df1, epsabs, imp, io, mode, iter, nsim, lb, ub, iz, rz, true)
  while (mode[1]>7 && it < max_iter)
    it += 1
    fk = f(xk)
    g!(gk, xk)
    if (print_iter)
       @printf("| %05d | %.3e | %.3e |\n", it, fk, norm(gk))
    end
    nsim=3*iter
    call_qnb!(xk, fk, gk, dxmin, df1, epsabs, imp,
              io, mode, iter, nsim, lb, ub, iz, rz, true)
  end
  return fk, xk
end


function call_n2qn1!(simu,
                     x::Vector{Float64},
                     f::Float64,
                     g::Vector{Float64},
                     dxmin::Vector{Float64},
                     df1::Float64,
                     epsabs::Vector{Float64},
                     imp::Int64,
                     io::Int64,
                     mode::Vector{Cint},
                     iter::Int64,
                     nsim::Int64,
                     binf::Vector{Float64},
                     bsup::Vector{Float64})
    @assert length(x) == length(g) == length(bsup) == length(binf)
    n = length(x)
    iz = zeros(Cint, 2*n+1) # why 1024
    rz = zeros(Float64, n*(n+9)÷2)
    ccall(n2qn1_ptr, Cvoid, (Ptr{Cvoid}, Ref{Cint},  Ref{Float64}, Ref{Float64}, Ref{Float64},  # simu, n , x, f , g
                             Ptr{Float64}, Ref{Float64}, Ptr{Float64}, Ref{Cint}, Ref{Cint},   # dxmin, df1, epsabs, imp, io
                             Ptr{Cint},    Ref{Cint},    Ref{Cint},                            # mode, iter, nsim
                             Ptr{Float64}, Ptr{Float64}, Ptr{Cint},  Ptr{Float64},             # binf, bsup, iz, rz   
                             Ptr{Cint}, Ptr{Float32}, Ptr{Float64}),                           # izs, rzs, dzs 
                             simu, n, x, f, g,
                             dxmin, df1, epsabs, imp, io,
                             mode, iter, nsim,
                             binf, bsup, iz, rz, 
                             C_NULL, C_NULL, C_NULL) 
end


function f(x)
    return (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
end

function g!(G, x)
    G[1] = -2.0 * (1.0 - x[1]) - 400.0 * (x[2] - x[1]^2) * x[1]
    G[2] = 200.0 * (x[2] - x[1]^2)
end

lb = zeros(2)
ub = 3*ones(2)
x0 = [0.5, 0.5]

function getSimul(n, obj, grad!)
  function proxy!(indic::Ptr{Cint},n::Cint,x::Ptr{Float64},f::Ptr{Float64},g::Ptr{Float64},izs::Ptr{Cint},rzs::Ptr{Float32},dzs::Ptr{Float64})
    if (unsafe_load(indic, 1)==4)
       xv = zeros(n)
       gv = zeros(n)
       for i=1:n
        xv[i] = unsafe_load(x, i)
       end
       grad!(gv,xv)
       for i=1:n
        unsafe_store!(g, gv[i], i)
       end
       fv = obj(xv)
       unsafe_store!(f,fv)
    end     
    nothing
  end
  return proxy!
end 

function bfgsb_direct(f,g!, 
                      x0::Vector{Float64}, 
                      lb::Vector{Float64}, 
                      ub::Vector{Float64};
                      dxmin::Vector{Float64}=1e-12*ones(size(x0,1)),
                      print_iter::Bool=false,
                      max_iter::Int64=300)
  # allocate 
  n = length(x0)
  xk = copy(x0)
  gk = zeros(length(x0))
  # init parameters
  df1 = f(x0)
  mode = ones(Cint, 1)
  imp = 1 
  iter = 1000
  nsim=3*iter
  io = 6  
  fk=df1
  g!(gk,x0)
  epsabs = 5e-5*ones(1)*norm(gk)
  simu = @cfunction($(getSimul(n, f, g!)), Cvoid, (Ptr{Cint}, Ref{Cint}, Ptr{Float64}, Ptr{Float64}, Ptr{Float64}, Ptr{Cint}, Ptr{Float32}, Ptr{Float64}))
  call_n2qn1!(simu, xk, fk, gk, dxmin, df1, epsabs, imp, io, mode, iter, nsim, lb, ub)
  return fk, xk
end

init_qnb()
fsol, xsol = bfgsb_direct(f, g!,  x0, lb,ub)



@testset "getSimu" begin
    io = open("dummy.f", "w")
    prgm="""
               subroutine compute_simu(simu,n,x0,f0,g0)
               integer*4 n,indic,izs(1)
               real*8 x0(n),g0(n),f0
               real*8 dzs(1)
               real*4 rzs(1)
               external simu               
               indic=4
               izs(1) = 0
               rzs(1) = 0.0
               dzs(1) = 0.0 
               call simu(indic, n, x0, f0, g0, izs, rzs, dzs)
               end subroutine   
         """
    write(io,prgm)
    close(io)
    run(`gfortran -o dummy.so -shared dummy.f`)
    n = 2
    function f(x)
       return (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
    end

    function g!(G, x)
        G[1] = -2.0 * (1.0 - x[1]) - 400.0 * (x[2] - x[1]^2) * x[1]
        G[2] = 200.0 * (x[2] - x[1]^2)
    end


    simu = @cfunction($(getSimul(n, f, g!)), Cvoid, (Ptr{Cint}, Ref{Cint}, Ptr{Float64}, Ptr{Float64}, Ptr{Float64}, Ptr{Cint}, Ptr{Float32}, Ptr{Float64}))
    test_simu = dlopen("./dummy.so")
    test_ptr = dlsym(test_simu, :compute_simu_)
    x0 = [0.33, 2.]
    f0 = [1.]
    g0 = zeros(2)
    gc = zeros(2)
    g!(gc,x0)
    ccall(test_ptr, Cvoid, (Ptr{Cvoid}, Ref{Cint}, Ptr{Float64}, Ptr{Float64}, Ptr{Float64}), simu, n, x0, f0, g0)
    @test f0[1] ≈ f(x0) atol=1e-30
    @test norm(g0-gc) < 1e-30
    run(`rm dummy.so dummy.f`)
end

