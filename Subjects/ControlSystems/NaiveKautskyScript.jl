using LinearAlgebra

n = 4
m = 2
A = [1.380 -0.2077 6.715 -5.676;
     -0.5814 -4.290 0.0 0.6750;
     1.067 4.273 -6.654 5.893;
     0.0480 4.273 1.343 -2.104]

B = [0 5.679 1.136 1.136;
     0 0 -3.146 0]'

eiglist = [-0.2, -0.5, -5.0566, -8.6659]

Bsvd = svd(B; full = true)
U = Bsvd.U
S = Diagonal(Bsvd.S)
Vt = Bsvd.Vt 

U0 = U[:,1:m]
U1 = U[:,m+1:end]
Z = S*Vt

X = similar(A)
for (index, λ) in pairs(eiglist)
    global X
    A1 = U1'*(A-λ*I(n))
    A1svd = svd(A1)
    Shat = A1svd.V
    S1 = nullspace(A1)
    x = rand([S1[:,i] for i in axes(S1, 2)])
    X[:,index] .= x 
end

rank(X)
# M = X*Diagonal(eiglist)*inv(X)
M = (X' \ (Diagonal(eiglist)*X'))'
F = inv(Z)*U0'*(M-A)










