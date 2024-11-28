using SparseArrays
using LinearSolve
using LinearAlgebra

# Constructing sparse array 
function hess_sparse(x::Vector{T}) where T
    return [-sin(x[1] + x[2]) + 1, -sin(x[1] + x[2]), -sin(x[1] + x[2]), -sin(x[1] + x[2]) + 1.0, 1.0, 1.0, 12.0*x[5]^2 + 1.0, 1.0]
end
rowval = [1, 1, 2, 2, 3, 4, 5, 6]
colval = [1, 2, 1, 2, 3, 4, 5, 6]

# Constructing sparse vec
function grad_sparse(x::Vector{T}) where T<: Number
    return [cos(x[1] + x[2]), cos(x[1] + x[2]), 2*x[3], 1/2, 4*x[5]^3, 1/2]
end
gradinds = [1, 2, 3, 4, 5, 6]

# Forming the matrix and vector
x0 = [0.7853981648713337, 0.7853981693418342, 1.023999999999997e-7, -1.0, 0.33141395338218227, -1.0]
n = length(x0)
hess_mat = sparse(rowval, colval, hess_sparse(x0), n, n) 
grad_vec = sparsevec(gradinds, grad_sparse(x0), n)

# # Sparse linear solve fails
# # This succeds in Matlab
# x = hess_mat \ grad_vec

# # Converting grad_vec to dense succeds in solving
# x =  hess_mat \ Array(grad_vec)

# # Converting grad_vec to dense succeds in solving
prob =  LinearProblem(hess_mat, Array(grad_vec))
linsolve = init(prob)
@show x = solve(linsolve)

# Linear Solve fails with sparse grad_vec
prob =  LinearProblem(hess_mat, grad_vec)
# linsolve = init(prob, IterativeSolversJL_GMRES())
# linsolve = init(prob, RFLUFactorization()) 
linsolve = init(prob, KrylovJL_GMRES()) 
x = solve(linsolve)

