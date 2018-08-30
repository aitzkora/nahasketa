using Test
"""
genereBase(n::Int)
  generate the vector columns of a basis of matrices with a null trace
"""
function genereBase(n::Int)
    a=zeros(Int, n*n, n*n -1)
    for k=1:n-1
        a[:,k] = vec(Diagonal([1 ; -1 * [i==k for i=1:n-1]]))
    end
    k=n
    for j=1:n
        for i=1:n
            if (i!=j)
                a[:,k] = vec(reshape([w==i for w=1:n],n,1)*reshape([w==j for w=1:n],1,n))
                k+=1
            end
        end
    end
    return a
end
@test genereBase(2) == [1 0 0; 0 1 0 ; 0 0 1; -1 0 0]
@test genereBase(3) == [ 1 1 0 0 0 0 0 0;
                         0 0 1 0 0 0 0 0;
                         0 0 0 1 0 0 0 0;
                         0 0 0 0 1 0 0 0;
                         -1 0 0 0 0 0 0 0;
                         0 0 0 0 0 1 0 0;
                         0 0 0 0 0 0 1 0;
                         0 0 0 0 0 0 0 1;
                         0 -1 0 0 0 0 0 0]
