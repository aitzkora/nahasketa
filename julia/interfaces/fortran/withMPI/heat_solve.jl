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
to2D(dims::Tuple{Int32, Int32}, rank::Int32)

convert a 1D rank to a 2D rank wrt a cartesian grids 
"""

function to2D(dims::Tuple{Int32, Int32}, rank)
    return (Int32(rank % dims[1]), Int32(rank % dims[2]))
end

function setBounds(coo::Tuple{Int32,Int32} , pX::Int32, pY::Int32, u::Array{Float64,2})
    if (coo[1] == 0)
        u[1,   :] .= 1.
    end
    if coo[1] == (pX - 1)
        u[end, :] .= 1.
    end
    if coo[2] == 0
        u[:,   1] .= 1.
    end
    if coo[2] == (pY - 1)
        u[:, end] .= 1.
    end
end

function main()
    MPI.Init()
    comm = MPI.COMM_WORLD
    commSize = MPI.Comm_size(comm)
    commRank = MPI.Comm_rank(comm)
    MPI.Barrier(comm)
    nArg = size(ARGS, 1)
    if (nArg < 5)
        usage()
    end
    nX, nY, iterMax, pX, pY = map(x->parse(Int32, x), ARGS)

    # checks than pX*pY == commSize
    if (pX * pY != commSize)
        if (commRank == 0)
            println(pX * pY, "!=", commSize)
        end
        MPI.Finalize()
        exit(code=1)
    end

    snapshotStep = 10
    snapshotSize = iterMax ÷ snapshotStep
    solution = zeros(nX, nY, snapshotSize)
    setBounds(to2D((pX, pY), commRank), pX, pY, solution[:,:, 1])

    for time=1:iterMax
        ccall((:solve, "./libheat.so"), Cvoid,
        (Ref{Int32}, Ref{Int32}, Ref{Int32}, Ref{Int32},  Ref{Int32},  Ref{Int32}, Ref{Int32}, Ptr{Float64}),
         nX, nY, pX, pY, snapshotStep, snapshotSize,  iterMax, solution
        )
    end
    MPI.Finalize()
end

main()
