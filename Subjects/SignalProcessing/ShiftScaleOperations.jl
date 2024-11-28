using LinearAlgebra
using Plots

t = LinRange(0, 2, 101)
plot(t, y1fun(t))

# Time shifting. Delay shifts the plot to right. Plot starts late.
Td = 1
y2 = y1fun(t .- Td)
plot!(t, y2)

# Time scaling
a = 0.5
y3 =  y1fun(t./a)
plot!(t, y3)

# Function which is zero for t<0 and equals e^{-2t} for t>0
function y1fun(t)
    n = length(t)
    y1 = zeros(n)
    for i=1:n 
        if t[i] < 0
            y1[i] = 0.0
        else
            y1[i] = exp(-2*t[i])
        end
    end
    return y1
end