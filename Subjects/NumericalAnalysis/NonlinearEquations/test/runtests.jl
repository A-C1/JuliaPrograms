using NonlinearEquations
using Test

func(x) = x^3 - 30*x^2 + 2552
funcd(x) = 3*x^2 -60*x
func1(x) = 2.5*sinh(x/4) - 1.0
g(x) = exp(-x)
fn(x) = 2*cosh(x/4) - x
fnd(x) = 0.5*sinh(x/4) - 1

@testset "bisect" begin
	x, n = bisect(func, -10.0, 10.0, 1.0e-8)
	println(x)
	@test ( (x<=-8.17 && x >=-8.18) && n == 30)
end

x = newtons_method(fn, fnd, 10.0, 1.0e-8)

# x = fixed_point_iteration(g, 1.0, 1.0e-8)

x = secant_method(fn, fnd, 10.0, 8.0, 1.0e-8)