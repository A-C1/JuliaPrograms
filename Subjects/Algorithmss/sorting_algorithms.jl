function combinems(A1, A2)
    A1 = copy(A1); A2 = copy(A2)
    Ac = eltype(A1)[]
    index = 1
    
    for i=1:length(A2)
        while(index <= length(A1) && A1[index] < A2[i])
            push!(Ac, A1[index])
            index = index + 1
        end
        push!(Ac, A2[i])
    end

    if (index <= length(A1))
        push!(Ac, A1[index:end]...)
    end

    return Ac
end

function mergesort(A)
    A = copy(A)
    n = length(A)

    if (n == 1)
        return A
    end

    if (n % 2) == 0
        p = Int(n/2)
    else
        p = Int((n+1)/2)
    end

    A1 = mergesort(A[1:p])
    A2 = mergesort(A[p+1:end])
    A_sorted = combinems(A1, A2)

    # @infiltrate
    return A_sorted
end

function insertionsort(A)
    A = copy(A)
    n = length(A)
    
    for i = 2:n
    end
end

A = [5, 4, 3, 2, 1]
