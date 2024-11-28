using Random, Plots

M = 100000
meanest = 0
rng = MersenneTwister(0)
x = randn(rng,M)
for i=1:M
	global meanest
	meanest = meanest + (1/M)*x[i]
end
# display(plot(x))
print(meanest)