using AutoGrad
using Plots

x = collect(0:0.1:10) 
y = x.^2 .+ x .+ 1

struct Model
	W
	b
end

m = Model(Param(zeros(2)), Param(zeros(1)))

(m::Model)(x) = m.W' * [x^2, x] + m.b'*[1]

function loss(X, Y, m)
	n = length(Y)
	sum = zero(eltype(X))
	for i=1:n
		sum += (Y[i] - m(X[i]))^2/n
	end
	return sum
end


for i=1:10
	local L = @diff loss(x, y, m)
	m.W .-= 1e-4*grad(L, m.W)
	m.b .-= 1e-4*grad(L, m.b)
end


plot(m.(x))
plot!(y)