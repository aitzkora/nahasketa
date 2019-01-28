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
function main()
    MPI.Init()
    comm = MPI.COMM_WORLD
    commSize = MPI.Comm_size(comm)
    commRank = MPI.Comm_rank(comm)
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
    snapshotSize = max(iterMax ÷ snapshotStep, 1)
    iter = iterMax
    solution = zeros(nX, nY, snapshotSize)

    ccall((:solve, "./libheat_solve.so"), Cvoid,
    (Ref{Int32}, Ref{Int32}, Ref{Int32}, Ref{Int32},  Ref{Int32},  Ref{Int32}, Ref{Int32}, Ptr{Float64}),
     nX, nY, pX, pY, snapshotStep, snapshotSize,  iter, solution
    )
    if (commRank == 0)
        indexToDisplay = (iter == iterMax ? snapshotSize : (iter ÷ snapshotStep))
        show(stdout, "text/plain", solution[:, : , indexToDisplay]);
    end
    MPI.Finalize()
end

main()
