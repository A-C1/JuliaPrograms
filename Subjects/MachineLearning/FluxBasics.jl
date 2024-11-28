using Flux

f(x) = 3x^2 + 2x +1
df(x) = gradient(f, x)[1]
df(2)

d2f(x) = gradient(df, x)[1]
d2f(2)

f(x, y) = sum((x .- y).^2)
gradient(f, [2, 1], [2, 0])

x = [2, 1]
y = [2, 0]

gs = gradient(params(x, y)) do
	f(x, y)
end

@show gs[x]
@show gs[y]
