using LinearAlgebra

function LU(A)
    display(A)
    L = zeros(n, n)
    for i = 1:n             # Selects the appropriate column
        L[i, i] = 1.0
        for j = i+1:n       # Goes over rows in the column
            L[j, i] = A[j, i] / A[i, i]
            for k = i:n# Modifies the rows in other columns 
                A[j, k] = A[j, k] - L[j, i] * A[i, k]
            end
        end
    end
    println("-------------")
    display(A)
    println("-------------")
    display(L)
end

# Vectorized
# A = rand(n, n)
# L = zeros(n, n)
# for i = 1:n
# 	L[i, i] = 1
# end

# display(A)

# for i = 1:n         	# Selects the appropriate column
# 	l = A[i+1:end, i] / A[i, i]
# 	L[i+1:end, i] = l
# 	A[i+1:end,i+1:end] = A[i+1:end,i+1:end] - l*A[i, i+1:end]'
# end
# println("-------------")
# display(A)
# println("-------------")
# display(L)


# Pivoting A Upper triangular and storing pivots
function plu_local(A)
    A = deepcopy(A)
    L = Matrix{Float64}(I, n, n)
    display(A)

    p = collect(1:n)  # permutation vector
    for i = 1:n         # Selects the appropriate column
        q = (i - 1) + argmax(A[i:n, i])# Find the index of the maximum element
        p[[i, q]] = p[[q, i]]                       # Interchange the elements in the vector p
        l = A[i+1:end, i] / A[i, i]
        L[i+1:end, i] = l
        A[i+1:end, i:end] = A[i+1:end, i:end] - l * A[i, i:end]'
    end

    B = L*A
    B1 = similar(B)

    for i = 1:n
        B1[p[i],:] .= B[i,:]
    end

    return L, A, p
end

A = rand(4,4)
L, U, p = plu_local(A)