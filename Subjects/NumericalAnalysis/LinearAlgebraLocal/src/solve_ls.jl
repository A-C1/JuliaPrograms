function solve(A,b)
    L, tau = chol_ami(A)
    y = forwardsub(L, b)
    x = backwardsub(L', y)
    
    return x
end