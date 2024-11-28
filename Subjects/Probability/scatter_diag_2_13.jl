using Plots, Random

rng = MersenneTwister(0)
rng1 = MersenneTwister(1)

M = 10000 #number of trials
x1 = rand(rng,M)
x2 = rand(rng1,M)

scatter(x1, 0.5*(x1+x2))
