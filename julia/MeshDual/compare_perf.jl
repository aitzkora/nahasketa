using DelimitedFiles

struct Partition
  vsize::Array{Int64,2}
  epart::Array{Int64,2}
  npart::Array{Int64,2}
  edges::Array{Int64,2} 
  nodes::Array{Float64,2}
end 

function read_files(directory)
  vsize = readdlm(directory * "/" * "vsize.dat", '\n', Int)
  epart = readdlm(directory * "/" * "epart.dat", '\n', Int)
  npart = readdlm(directory * "/" * "npart.dat", '\n', Int)
  param_file = directory * "/"  * "param_simple_mumps.txt" 
  mesh_name = split(split(read(pipeline(`grep "mesh=" $param_file`), String))[1], "=")[2]
  # reading edges
  edge_file = open(mesh_name * ".1.edge")
  first = readline(edge_file)
  numbers  = map(x->parse(Int,x),split(first))
  n_tri = numbers[1]
  tri = zeros(Int64, n_tri, 4)
  for i=1: n_tri
    tri[i,:] = map(x->parse(Int64,x),split(readline(edge_file)))
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
