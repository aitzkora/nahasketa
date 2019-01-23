import MPI

function usage()

  arg1 = ARGS[1]
  println("Usage: mpirun -np nb_procs ", arg1, " N " )
  println("    N      size of the array")
  exit(code=1)
end

function main()
    MPI.Init()
    comm = MPI.COMM_WORLD
    commSize = MPI.Comm_size(comm)
    commRank = MPI.Comm_rank(comm)
    #MPI.Barrier(comm)
    nArg = size(ARGS, 1)
    if (nArg < 1 )
        usage()
    end
    N = parse(Int32, ARGS[1])

    x = zeros(Int32, N)
    x[:] = 1:N
    tot = Ref{Int32}(0)

    ccall((:calc_sum, "./libpar_sum2.so"), Cvoid, (Ref{Int32}, Ptr{Int32}, Ref{Int32}), N, x, tot)

    if (commRank == 0) 
        println("somme totale = ", tot[])
    end
    MPI.Finalize()
end

main()
