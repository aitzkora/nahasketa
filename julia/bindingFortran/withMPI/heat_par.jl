import MPI

function usage()

  arg1 = ARGS[1]
  println("Usage: mpirun -np (px*py) ", arg1, " nx ny iter_max px py")
  println("    nx       number of discretisation points in X")
  println("    ny       number of discretisation points in Y")
  println("    iter_max maximal number of iterations in temporal loop")
  println("    px       X process number")
  println("    py       Y process number")
  exit(code=1)
end

"""
to2D(dims::Tuple{Int64, Int64}, rank::Int64)

convert a 1D rank to a 2D rank wrt a cartesian grids 
"""

function to2D(dims::Tuple{Int64, Int64}, rank)
    return (rank % dims[1], rank % dims[2])
end

function main()
    MPI.Init()
    comm = MPI.COMM_WORLD
    commSize = MPI.Comm_size(comm)
    commRank = MPI.Comm_rank(comm)
    MPI.Barrier(comm)
    # do prints on the master
    verbose = (commRank == 0)
    nArg = size(ARGS, 1)
    if (nArg < 5)
        usage()
    end
    nX, nY, iterMax, pX, pY = map(x->parse(Int64, x), ARGS)

    # checks than pX*pY == commSize
    if (pX * pY != commSize)
        if (verbose)
            println(pX * pY, "!=", commSize)
        end
        MPI.Finalize()
        exit(code=1)
    end

    snapshotStep = 10
    snapshotSize = iterMax / snapshotStep
    solution = zeros(nX, nY, snapshotSize)
    ccall((:heat, "./libheat.so"), Ref{Int32}, Ref{Int32}, Ref{Int32}, Ref{Int32}, Ref{Int32}, Ptr{Float64}), nX, nY, pX, pY, snapshotStep, solution)

    MPI.Finalize()
end

main()
