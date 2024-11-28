using Plots, Random
rng = MersenneTwister(1)

M = 100
cnt = 0
x = randn(rng,M)

for i=1:M
	global cnt
	if x[i] > 2
		cnt = cnt + 1
	end
end
probest = cnt/M