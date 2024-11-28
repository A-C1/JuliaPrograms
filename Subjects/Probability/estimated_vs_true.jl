using Plots, Random
# randn('State' ,0)
rng = MersenneTwister(1)
global x = randn(rng,5000,1)
bincenters= collect(-3.5:0.5:3.5)'
binsLength = length(bincenters)
h = zeros(binsLength,1)

for i=1:length(x)
    global x, h
    for k=1:binsLength
        if (x[i] > bincenters[k]-0.5/2) && (x[i] <= bincenters[k]+0.5/2)
            h[k,1] = h[k,1] + 1
        end
    end
end


pxest=h/(length(x)*0.5)
xaxis=collect(-4:0.01:4)
px=(1/sqrt(2*pi))*exp.(-0.5*xaxis.^2);
fig1 = plot(xaxis, px, linewidth=5)
bar!(fig1, bincenters',pxest)
# display(histogram!(fig1, pxest[:,1], bins=bincenters'))