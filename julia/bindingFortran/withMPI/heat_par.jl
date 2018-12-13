import MPI


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

    cellX = nX / pX
    cellY = nY / pY
    sizeX = cellX + 2
    sizeY = cellY + 2

    MPI.Finalize()
end

main()
