using LinearAlgebra
using Polynomials
using Plots
import Base: +,-,/,*

struct ss
	A::Matrix{Float64}
	B::Matrix{Float64}
	C::Matrix{Float64}
	D::Matrix{Float64}
end

struct sisotf
	num::Polynomial
	den::Polynomial
end

(a::sisotf)(x) = a.num(x)/a.den(x)
num(a::sisotf) = a.num
den(a::sisotf) =  a.den
poles(a::sisotf) = roots(a.den)
zeros(a::sisotf) = roots(a.num)
+(a::sisotf, b::sisotf) = sisotf(a.num*b.den + b.num*a.den, a.den*b.den)
-(a::sisotf, b::sisotf) = sisotf(a.num*b.den - b.num*a.den, a.den*b.den)
*(a::sisotf, b::sisotf) = sisotf(a.num*b.num, a.den*b.den)
/(a::sisotf, b::sisotf) = sisotf(a.num*b.den , a.den*b.num)

function bodeplot(h::sisotf)
	ω = 0.01:0.01:10000
	bode = h.(ω*im)
	modH = abs.(bode)
	angH = angle.(bode) .* (180/3.14)
	plot(ω, angH, xaxis = :log)
end

function nyquist(h::sisotf)
	ω = 0.01:0.1:10000
	hVal = h.(-ω*im)
end


s1 = sisotf([100], [100, 1])
s2 = sisotf([100], [100, 1])
s = s1 - s2

plot(nyquist(s))
