using LinearAlgebra

struct ss{T<:Number}
	A::Matrix{T}
	B::Matrix{T}
	C::Matrix{T}
	D::Matrix{T}
end

function ss(A, B, C, D)
	T = promote_type(eltype(A), eltype(B), eltype(C), eltype(D))
	nin = size(B, 2)
	nout = size(C, 1)
	nx = size(A, 1)
	A1 = Matrix{T}(A)
	B1 = Matrix{T}(reshape(B, nx, nin))
	C1 = Matrix{T}(reshape(C, nout, nx))
	D1 = Matrix{T}(reshape(D, nout, nin))
	return ss(A1, B1, C1, D1)
end

A = [0 1.0; 0 0]; B = [0; 1]; C = [1 0; 0 1]; D = [0, 0]

sys = ss(A, B, C, D)