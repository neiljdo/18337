using BenchmarkTools
using StaticArrays


A = rand(100, 100)
B = rand(100, 100)
C = rand(100, 100)

function inner_rows!(C, A, B)
    for i in 1:100, j in 1:100
        C[i, j] = A[i, j] + B[i, j]
    end
end
@btime inner_rows!(C, A, B)

function inner_cols!(C, A, B)
    for j in 1:100, i in 1:100
        C[i, j] = A[i, j] + B[i, j]
    end
end
@btime inner_cols!(C, A, B)

typeof(A)

function inner_alloc!(C, A, B)
    for j in 1:100, i in 1:100
        val = [A[i, j] + B[i, j]]
        C[i, j] = val[1]
    end
end
@btime inner_alloc!(C, A, B)

function inner_noalloc!(C, A, B)
    for j in 1:100, i in 1:100
        val = A[i, j] + B[i, j]
        C[i, j] = val[1]
    end
end
@btime inner_noalloc!(C, A, B)


val = SVector{3, Float64}(1., 2., 3.)
typeof(val)

function static_inner_alloc!(C, A, B)
    for j in 1:100, i in 1:100
        val = @SVector [A[i, j] + B[i, j]]
        C[i, j] = val[1]
    end
end
@btime static_inner_alloc!(C, A, B)

function inner_alloc(A, B)
    C = similar(A)
    for j in 1:100, i in 1:100
        val = A[i, j] + B[i, j]
        C[i, j] = val[1]
    end
end
@btime inner_alloc(A, B)


function f(A, B)
    sum([A + B for k in 1:10])
end
@btime f(A, B)

# Alternative implementation to f above
function g(A, B)
    C = similar(A)
    for k in 1:10
        C .+= A .+ B
    end
    C
end
@btime g(A, B)

