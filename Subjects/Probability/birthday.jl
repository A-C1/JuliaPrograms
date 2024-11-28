using Random, Plots

rng = MersenneTwister(1234)
BD = collect(0:365)
event = zeros(10000) # initialize to no successful events
x = zeros(23)
for ntrial=1:10000
	for i=1:23
		x[i] = ceil(365*rand()) # chooses birthdays at random
								# ceil rounds up to nearest integer
	end
	y = sort(x)           # arranges birthdays in ascending order
	z = y[2:23] - y[1:22] # compares successive birthdays to each other
	w = z[z.==0]  # flags some birthdays
	if length(w) > 0
		event[ntrial] = 1
	end
end
prob = sum(event)/10000
	