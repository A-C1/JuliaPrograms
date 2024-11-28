using LinearAlgebra

function horner(c::Vector{Float64}, x::Float64)
	y = c[1]
	for i=2:length(c)
		y = y*x + c[i]
	end
	return y
end

c = [1, -3, 3, 1]

@show y = horner(c, 1.6)