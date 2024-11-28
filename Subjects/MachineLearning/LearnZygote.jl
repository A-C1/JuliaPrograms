using Zygote
import Base: +, -

# Gradient of a function returning a scalar
f(x) = 3x^2 + 2x + 1
gradient(f, 5)

f(a, b) =  a'*b
gradient(f, [0, 1], [0, 0])

W = rand(2, 3)
x = rand(3)
f(W, x) = sum(W*x)
gradient(f, W, x)[2]

function pow(x, n)
	r = 1
	for i=1:n
		r *= x
	end
	return r
end

gradient(x -> pow(x, 3), 5)

d = Dict()

gradient(5) do x
	d[:y] = x
	d[:y]*d[:y]
end

@show d[:y]

# Differentiation using Structs and Types
# Not understood well
struct Point
	x::Float64
	y::Float64
end

a::Point + b::Point = Point(a.x + b.x, a.y + b.y)
a::Point - b::Point = Point(a.x - b.x, a.y - b.y)
dist(p::Point) = sqrt(p.x^2 + p.y^2)
a = Point(1, 2)
b = Point(3, 4)
@show dist(a+b)

gradient(a-> dist(a+b), a)

# Explicit and Implicit parameters
lin