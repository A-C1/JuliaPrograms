# Poles must be complex conjugate of each other
# Match the matlab method
function complex_katausky(A, B, eiglist)

    Bsvd = svd(B; full=true)
    U = Bsvd.U
    S = Diagonal(Bsvd.S)
    Vt = Bsvd.Vt

    U0 = U[:, 1:m]
    U1 = U[:, m+1:end]
    Z = S * Vt

    X = similar(A)
    for (index, λ) in pairs(eiglist)
        global X
        A1 = U1' * (A - λ * I(n))
        A1svd = svd(A1)
        Shat = A1svd.V
        S1 = nullspace(A1)
        x = rand([S1[:, i] for i in axes(S1, 2)])
        X[:, index] .= x
    end

    rank(X)
    # M = X*Diagonal(eiglist)*inv(X)
    M = (X' \ (Diagonal(eiglist) * X'))'
    F = inv(Z) * U0' * (M - A)

end