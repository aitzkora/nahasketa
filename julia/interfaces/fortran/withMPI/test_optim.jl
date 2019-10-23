import MPI

function usage(rank)
  if (rank == 0) 
      println("Usage: mpirun -np nb_procs julia test_optim.jl N")
  end
  MPI.Finalize()
  exit()
end

function main()
    MPI.Init()
    comm = MPI.COMM_WORLD
    comm_size = MPI.Comm_size(comm)
    rank = MPI.Comm_rank(comm)
    n_arg = size(ARGS, 1)
    if (n_arg < 1 )
        usage(rank)
    end
    n = parse(Int32, ARGS[1])

    x = zeros(n)
    x[:] = 1:n
    f,df = simu(x)
    if (rank == 0) 
        println("cost function and gradient" , f, df)
    end
    MPI.Finalize()
end

function simu(x)
    f = Ref{Float64}(0.)
    n = convert(Int32, size(x, 1))
    c = cos.(1:n)
    df = zeros(n)
    ccall((:compute_error, "./libpar_error.so"), 
          Cvoid, (Ref{Int32}, Ptr{Float64}, Ptr{Float64}, Ref{Float64}, Ptr{Float64}), n, x, c, f, df)
    return f[] ,df
end

main()
