# Solve by writing a function
"""
x = forwardsub(L, b)
Solve a lower triangular linear system
Input:
L    lower triangular square matrix (n by n)
b    right-hand side vector (n dim vector)
Output:
x    Solution of Lx=b (n dim vector)
"""
function forwardsub(L, b)
	n = size(L, 1)
	x = zeros(n)
	for i = 1:n 
		x[i] = (b[i] - L[i,1:i-1]'*x[1:i-1])/L[i,i]
	end
	return x
end
# println(x)
# println(forwardsub(L, b))
@code_warntype forwardsub(L,b)

"""
x = backwardsub(L, b)
Solve an upper triangular linear system
Input:
L    lower triangular square matrix (n by n)
b    right-hand side vector (n dim vector)
Output:
x    Solution of Lx=b (n dim vector)
"""
function backwardsub(L, b)
	n = size(L, 1)
	x = zeros(eltype(L), n)
	for i = n:-1:1
		if i == N
			x[i] = b[i] / L[i, i]
		else
			x[i] = (b[i] - L[i, i+1:n]'*x[i+1:n]) / L[i,i]
		end
	end
end
