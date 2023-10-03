using GLMakie
using LinearAlgebra

# read a matrix of the following format
# nb_rows, nb_cols
# data on one line
function read_with_dim(filename, T)
    file = open(filename)
    first = readline(file)
    numbers  = map(x->parse(Int,x),split(first))
    nb_cols = numbers[1]
    nb_rows = numbers[2]
    nums = reshape(map(x->parse(T,x),split(readline(file))),nb_cols, nb_rows)
    close(file)
    return nums
end

function read_track(filename)
    file = open(filename)
    t₀ = (x->parse(Int64,x)).(split(readline(file)))
    pt = (x->parse(Float64,x)).(split(readline(file)))
    track = (α->parse(Int64,α)).(eachline(file))
    close(file)
    return t₀[1], pt, track
end 

function circle!(ax, p, col, r::Float64 = 0.1, N::Int64 = 10)
     α = LinRange(0.,2π, N)
     x = p[1] .+ r * cos.(α)
     y = p[2] .+ r *  sin.(α)
     lines!(ax, x, y; color = col, linewidth=5)
end



function calc_bary(x, x0)

  a = x[1,1] - x[1,3] 
  b = x[1,2] - x[1,3]
  c = x[2,1] - x[2,3]
  d = x[2,2] - x[2,3]
  denom = a * d - b * c

  if (abs(denom)/norm(x,2) < 1e-10)
     @warn "pb in compute_barycenters"
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

using Printf

function find_triangle(coo, nodes, triangles, neighbors, filename::String = "")
  cell = 1
  found = false
  logging = !isempty(filename)
  if (logging)
    file = open(filename, "w")
    println(file, 0)
    @printf(file, "%f %f", coo...)
  end 
  while !found
    θ = calc_bary(nodes[triangles[cell,:],:]', coo)
    if (all(θ .> 0))
      found = true
    else
      θₙ = findall(.≠(0), neighbors[cell,:]) ∩ findall(.<=(0), θ) 
       if isempty(θₙ)
        @warn "$coo not found"
        break
      else
        cell = neighbors[cell, argmax(i->abs(θ[i]), θₙ)]
        if (logging) println(file, cell) end
      end
    end  
  end
  if (logging) close(file) end
  return cell
end

function plot_track(nodes, triangles, filename)
  t₀, п, track = read_track(filename)
  bars = sum(nodes[triangles[track,:],:] / 3., dims=2)[:,1,:]
  mycols = fill(:white, size(triangles))
  mycols[1] = :red
  #mycols[t₀] = :red
  fig, ax, plot = poly(nodes, triangles; color=mycols , strokewidth=1, shading=false, alpha=1., axis = (;aspect = DataAspect()))
  p₀ = sum(nodes[triangles[1,:],:] / 3., dims=2)[:,:]
  
  lines!(ax, bars[:,1], bars[:,2]; color = :red)
  text!(ax, bars[1,1], bars[1,2]; text="depart", fontsize=32) # text to situate the depart
  text!(ax, п[1], п[2]; text="depart", fontsize=40) # text to situate helmuga
  DataInspector(fig)
  display(fig)
end

function generate_targets(nodes, triangles, n::Int64 = 1)
  nₜ = maximum(triangles)
  targets = rand(1:nₜ, n)
  barycenters = zeros(n, 2)
  for i=1:n 
    α = rand(2) / 2.
    append!(α, 1. - sum(α))
    barycenters[i,:] = sum(α .* nodes[triangles[targets[i],:],:],dims=1)
  end
  return targets, barycenters
end

nodes = read_with_dim("x_node.txt", Float64)'
triangles = read_with_dim("cell_node.txt", Int64)'
neighbors = read_with_dim("neigh.txt", Int64)'
t₀, п, track = read_track("track_1.txt")

n = convert(Int64, floor(maximum(triangles) * 0.2))
targets, barys = generate_targets(nodes, triangles, n)
using Test
for i=1:n
  ind = find_triangle(barys[i,:], nodes, triangles, neighbors)
  if (ind != targets[i])
    println("😐: $ind != $(targets[i])")
  else
    println("👍: $ind == $(targets[i])")
  end
end
