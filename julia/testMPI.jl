import MPI
using Statistics:mean
function communicate()
    MPI.Init()
    comm = MPI.COMM_WORLD
    size = MPI.Comm_size(comm)
    rank = MPI.Comm_rank(comm)
    recv_mesg = zeros(100, 1)
    if (rank == 0)
        send_mesg = rand(100,1)
        for i=1:size - 1
            MPI.Send(send_mesg, i, 0, comm)
        end
    else
        MPI.Recv!(recv_mesg, 0, 0, comm)
    end
    m = mean(recv_mesg, dims=1)
    sleep(rank * 2)
    println("results on rank ", rank, ": ", m)
    MPI.Barrier(comm)
    MPI.Finalize()
end

communicate()
