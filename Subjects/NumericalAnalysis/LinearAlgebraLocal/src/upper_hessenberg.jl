using LinearAlgebra
n = 3

A = rand(n, n)
display(A)
L = zeros(n,n)
for i = 1:n         	# Selects the appropriate column
	L[i, i] = 1.0
	for j=(i+1):n       # Goes over rows in the column
		L[j, i] = A[j, i]/A[i, i]
		for k=i:n		# Modifies the rows in other columns 
			A[j, k] = A[j, k] - L[j, i]*A[i, k]
		end
	end
end
println("-------------")
display(A)
println("-------------")
display(L)