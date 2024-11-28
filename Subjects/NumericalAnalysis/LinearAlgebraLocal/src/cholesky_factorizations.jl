using DelimitedFiles

function chol(A)
    A = deepcopy(A)
    n = size(A, 1)
    L = zeros(n,n)

    for j=1:n
        for i = j:n 
            L[i,j] = A[i,j]
            if j != 1  # This can be replaced with inner product formulation
                for s = 1:j-1
                    L[i,j] = L[i,j] - L[i,s]*L[j,s]
                end
            end

            if i==j
                if L[i,j] <= 0
                    return zeros(n,n), false
                end
                L[i,j] = sqrt(L[i,j])
            else
                L[i,j] = L[i,j] / L[j,j]
            end
        end
    end

    return L, true
end

A = rand(4, 4)
chol(A)

function ldl1(A)
    A = deepcopy(A)
    # This is the ldl factorization
    for i = 1:n
        s = i > 1 ? reduce(+, [(D[k,k]*L[i,k]^2) for k = 1:i-1]) : 0
        D[i,i] = A[i,i] - s
        for j=i+1:n
            s = i > 1 ? reduce(+,[D[k,k]*L[j,k]*L[i,k] for k=1:i-1]) : 0
            L[j,i] = (A[j,i] - s) / D[i,i]
        end
    end
end

function ldl(A)
    A = deepcopy(A)
    n = size(A,1)
    D = zeros(n,n)
    L = I(n) + zeros(n,n)

    for j = 1:n
        if j == 1
            D[j,j] = A[1,1]
        else
            D[j,j] = A[j,j]
            for s = 1:j-1
                D[j,j] = D[j,j] - D[s,s]*L[j,s]^2
            end
        end

        for i = j+1:n 
            L[i,j] = A[i,j]
            for s = 1:j-1
                L[i,j] = L[i,j] - D[s,s]*L[i,s]*L[j,s]
            end
            L[i,j] = L[i,j] / D[j,j]
        end
    end

    return L, D
end

function chol_ami(A)
    A = deepcopy(A)
    n = size(A,1)
    L = zeros(n,n)
    beta = 0.1
    ad = [A[i,i] for i=1:n]

    amin, _ = findmin(ad)
    if amin > 0
        tau0 = 0
    else
        tau0 = -amin + beta
    end
    LUsuccess = false

    while !LUsuccess
        L, LUsuccess = chol(A + tau0*I(n))
        tau0 = max(2*tau0, beta)
    end

    return L, tau0
end


function ldl_ami(A)
    A = deepcopy(A)
    beta = 1.0
    delta = 1.0

    n = size(A,1)
    D = zeros(n,n)
    L = I(n) + zeros(n,n)

    for j = 1:n
        if j == 1
            D[j,j] = A[1,1]
        else
            D[j,j] = A[j,j] 
            for s = 1:j-1
                D[j,j] = D[j,j] - D[s,s]*L[j,s]^2
            end
        end
        for i=j+1:n
            L[i,j] = A[i,j]
            for s = 1:j-1
                L[i,j] = L[i,j] - D[s,s]*L[i,s]*L[i,s]
            end
            theta, _ = findmax(L[j+1:n,n])
            D[j,j] = max(abs(D[j,j]), (theta/beta)^2, delta)
            L[i,j] = L[i,j] / D[i,j]
        end
    end

    return L, D
end

function sidf(A)
    A = deepcopy(A)
end