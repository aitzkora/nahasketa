import MPI

function usage()

  arg1 = ARGS[1]
  println("Usage: mpirun -np (px*py) ", arg1, " nx ny iter_max px py")
  println("    nx       number of discretisation points in X")
  println("    ny       number of discretisation points in Y")
  println("    px       X process number")
  println("    py       Y process number")
  println("    iter_max maximal number of iterations in temporal loop")
  println("    snapshot_step we save solution every snapshot_step")
    exit(code=1)
end

include("plot_heat.jl")

function main()
    MPI.Init()
    comm = MPI.COMM_WORLD
    commSize = MPI.Comm_size(comm)
    commRank = MPI.Comm_rank(comm)
    nArg = size(ARGS, 1)
    if (nArg < 6)
        usage()
    end
    nX, nY, pX, pY, iterMax, snapshotStep = map(x->parse(Int32, x), ARGS)

    # checks than pX*pY == commSize
    if (pX * pY != commSize)
        if (commRank == 0)
            println(pX * pY, "!=", commSize)
        end
        MPI.Finalize()
        exit(code=1)
    end
    @assert snapshotStep < iterMax
    snapshotSize = max(iterMax ÷ snapshotStep, 1)
    iter = Ref{Int32}(iterMax) # very important
    solution = zeros(nX, nY, snapshotSize)

    ccall((:solve, "./libheat_solve.so"), Cvoid,
    (Ref{Int32}, Ref{Int32}, Ref{Int32}, Ref{Int32},  Ref{Int32},  Ref{Int32}, Ref{Int32}, Ptr{Float64}),
     nX, nY, pX, pY, snapshotStep, snapshotSize,  iter, solution
    )
    iter = iter[] # very important
    if (commRank == 0)
        indexToDisplay = (iter == iterMax ? snapshotSize : (iter < snapshotSize ? iter ÷ snapshotStep : 1))
        println("iter = $iter, indexToDisplay = $indexToDisplay")
        show(IOContext(stdout, :limit=>true), "text/plain", solution[:, : , indexToDisplay]);
        #heatPlot(solution[:,:,1:indexToDisplay])
    end
    MPI.Finalize()
end

main()
