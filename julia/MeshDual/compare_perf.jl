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
  return accu
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
