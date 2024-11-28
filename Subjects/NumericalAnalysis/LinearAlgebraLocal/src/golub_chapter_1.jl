function dot_product(x, y)
	c = 0.0
	for i in eachindex(x)
		c = c + x[i]*y[i]
	end
	return c
end

function saxpy(a, x, y)
	for i in eachindex(y)
		y[i] = y[i] + a*x[i]
	end
	return y
end

# Row oriented generalized Ax + y (Gaxpy)
function rogaxpy(A, x, y)
	for i in eachindex(y)
		for j in eachindex(x)
			y[i] = y[i] + A[i,j]*x[j]
		end
	end
	return y
end

function cogaxpy(A, x, y)
	for i in eachindex(x)
		for j in eachindex(y)
			y[j] = y[j] + A[i,j]*x[i]
		end
	end
	return y
end

# Outer product updates
# A = A + x*Y
function col_oriented_element_wise(A, x, y)
	for i in eachindex(y) 
		for j in eachindex(x)
			A[j,i] = A[j,i] + y[i]*x[j]
		end
	end
end

function mat_mul!(C, A, B)
	for i in axes(C, 1)
		for j in axes(C, 2)
				C[i, j] = A[i, :]'*B[:,j]
		end
	end
end

x =  [1, 1]
y = [6, 5]
a = 2.0
A = [1.0 0; 0 1.0]
B = I(2)
C = zeros(2, 2)
mat_mul!(C,A,B)

# println(dot_product(x, y))
# println(saxpy(a, x, y))
# println(@time rogaxpy(A, x, y))
# println(@ben rogaxpy(A, x, y))