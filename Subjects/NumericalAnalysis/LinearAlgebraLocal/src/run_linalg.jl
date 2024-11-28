using LinearAlgebra

include("LinearAlgebraLocal.jl")

import .LinearAlgebraLocal as LA

A1 = rand(4,4)

A = A1*A1'
 
L, tau = LA.chol_ami(A)

b = rand(4)

x = LA.solve(A, b)

x1 = A \ b