using DelimitedFiles
using LightGraphs
using MeshDual


struct Partition
  vsize::Array{Int64,2}
  epart::Array{Int64,2}
  npart::Array{Int64,2}
  triangles::Array{Int64,2} 
  nodes::Array{Float64,2}
end 

function read_files(directory)
  vsize = readdlm(directory * "/" * "vsize.dat", '\n', Int)
  epart = readdlm(directory * "/" * "epart.dat", '\n', Int)
  npart = readdlm(directory * "/" * "npart.dat", '\n', Int)
  param_file = directory * "/"  * "param_simple_mumps.txt" 
  mesh_name = split(split(read(pipeline(`grep "mesh=" $param_file`), String))[1], "=")[2]
  # reading triangles
  edge_file = open(mesh_name * ".1.ele")
  first = readline(edge_file)
  numbers  = map(x->parse(Int,x),split(first))
  n_tri = numbers[1]
  tri = zeros(Int64, n_tri, 3)
  for i=1: n_tri
    tri[i,:] = map(x->parse(Int64,x),split(readline(edge_file)))[2:4]
  end
  close(edge_file)
  # reading nodes
  node_file = open(mesh_name * ".1.node")
  first = readline(node_file)
  numbers  = map(x->parse(Int,x),split(first))
  n_nodes = numbers[1]
  nodes = zeros(Float64, n_nodes, 4)
  for i=1: n_nodes
    nodes[i,:] = map(x->parse(Float64,x),split(readline(node_file)))
  end
  close(node_file)
  return Partition(vsize, epart, npart, tri, nodes)
end

function edge_cut(p::Partition)
  dual = graph_dual(Mesh([p.triangles[i,:] for i=1:size(p.triangles,1)]),2)
  accu = 0
  for i=1:size(dual.adj, 1)
    for j in dual.adj[i]
      if (p.epart[j] != p.epart[i]) 
        accu+=1
      end
    end
  end
  return accu / 2
end

function total_com_vol(p::Partition)
  dual = graph_dual(Mesh([p.triangles[i,:] for i=1:size(p.triangles,1)]),2)
  N_adj = zeros(Int64, size(dual.adj,1))
  nb_inter = 0
  for i=1:size(dual.adj, 1)
    accu = 0 
    for j in dual.adj[i]
      if (p.epart[j] != p.epart[i]) 
        accu += 1
      end
    end
    if (accu > 0) 
      N_adj[i] = accu
      nb_inter += 1
    end
    if accu > 0
      println("info = $i, $accu, $nb_inter")
    end
  end
  tot_vol = 0
  #println("nb_inter = " nb_inter
  for i=1:size(dual.adj,1)

    if (N_adj[i] > 0)
      tot_vol += p.vsize[i] * N_adj[i]
    end
  end
  return tot_vol
end


function total_com_vol_2(vertnnd::Int64, verttax, edgetax, vsize, epart)
  N_adj = zeros(Int64, vertnnd)
  nb_inter = 0
  for vertnum=1:vertnnd-1
    accu = 0 
    partval = epart[vertnum]
    for j=verttax[vertnum]:verttax[vertnum+1]
      if (epart[edgetax[j+1]] != partval) 
        accu += 1
      end
    end
    if (accu > 0) 
      N_adj[vertnum] = accu
      nb_inter += 1
    end
  end
  tot_vol = 0
  for i=1:vertnnd-1
    if (N_adj[i] > 0)
      tot_vol += vsize[i] * N_adj[i]
    end
  end
  return tot_vol
end


w1 = read_files("/home/fux/sources/hou10ni2d/build")
w2 = read_files("/home/fux/sources/hou10ni2d/build_with_scotch")

function write_msh(p::Partition, filename)
  n_nodes=size(p.nodes,1)
  n_triangles=size(p.triangles,1)
  file = open(filename, "w")
  print(file, "MeshVersionFormatted 1\nDimension\n2\n")
  print(file,"\nVertices\n$n_nodes\n")
  for i=1:n_nodes
    println(file, p.nodes[i,2], " ", p.nodes[i,3], " " ,p.npart[i])
  end
  print(file,"\nTriangles\n$n_triangles\n")
  for i=1:n_triangles
    println(file, p.triangles[i,1], " " , p.triangles[i,2], " ", p.triangles[i,3], " " ,p.epart[i])
  end
  close(file)
end

function read_mesh(filename, ::Val{D}) where {D}
  @assert Val(D) isa Union{map(x->Val{x},1:3)...}
  lines = readlines(filename)
  lines = lines[map(x-> length(x) > 0 && (x[1] != '#'), lines)] # beware to the '
  f_s(x) = findall(map(y->occursin(x,y),lines))[1]
  dim = parse(Int64,lines[f_s("Dimension")+1])
  @info "dim =", dim
  @assert  D == dim
  of_nodes = f_s("Vertices")
  nb_nodes = parse(Int64, lines[of_nodes + 1])
  nodes = zeros(Float64, nb_nodes, dim)
  for i=1:nb_nodes
    nodes[i, : ] = map(x->parse(Float64,x), split(lines[of_nodes + 1 + i])[1:end-1])
  end
  @info "nodes=", nodes
  if (dim == 2)
    of_elem = f_s("Triangles")
  else
    of_elem = f_s("Tetrahedra")
  end
  nb_elem = parse(Int64, lines[of_elem + 1])
  elements = zeros(Int64, nb_elem, dim + 1)
  for i=1:nb_elem
    elements[i, : ] = map(x->parse(Int64,x), split(lines[of_elem + 1 + i])[1:dim+1])
  end
  SimplexMesh{D}(nodes, elements)
end

function adj_to_eptr_eind(adj)
  eptr = Cint[0]
  eind = Cint[]
  for i=1:size(adj,1)
    append!(eptr, eptr[i] + size(adj[i],1))
    append!(eind, adj[i])
  end
  return eptr, eind
end

using Libdl: dlopen, dlsym
function scotch_output_vol(p::Partition)
    if "SCOTCHMETIS_LIB"  in keys(ENV)
        scotch_str = ENV["SCOTCHMETIS_LIB"]
    else
        @error "must define the env variable SCOTCH_LIB"
    end
    lib_scotch = dlopen(scotch_str; throw_error=false)
    @debug lib_scotch
    @assert lib_scotch != nothing
    output_vol_ptr = dlsym(lib_scotch, :_SCOTCH_METIS_OutputVol2)
    @debug "_SCOTCH_METIS_OutputVol Pointer", output_vol_ptr
    volume = Ref{Cint}(0)
    partnbr = maximum(p.npart) + 1
    vertnnd = size(p.epart, 1)
    dual = graph_dual(Mesh([p.triangles[i,:] for i=1:size(p.triangles,1)]),2)
    eptr, eind = adj_to_eptr_eind(dual.adj)
    @info "vertnnd = ", vertnnd
    @info "partnbr =", partnbr
    ccall(output_vol_ptr, Cint, 
          (Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Cint, Ptr{Cint}, Ref{Cint}),
          Cint(0),
          Cint(vertnnd),
          eptr,
          eind,
          map(Cint,p.vsize),
          Cint(partnbr),
          map(Cint,p.epart),
          volume
         )
    return volume
end

function scotch_sizeof()
    if "SCOTCH_LIB"  in keys(ENV)
        scotch_str = ENV["SCOTCH_LIB"]
    else
        @error "must define the env variable SCOTCH_LIB"
    end
    lib_scotch = dlopen(scotch_str; throw_error=false)
    @debug lib_scotch
    @assert lib_scotch != nothing
    scotch_num_sizeof_ptr = dlsym(lib_scotch, :SCOTCH_numSizeof)
    w = ccall(scotch_num_sizeof_ptr, Cint, (),)
    return w
end

tv_1 = scotch_output_vol(w1)
tv_2 = scotch_output_vol(w2)

@info tv_1
#@info tv_2
#@info total_com_vol(w1)
#@info total_com_vol(w2)
