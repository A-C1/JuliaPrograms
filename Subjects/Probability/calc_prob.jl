using Plots

x1 = 1
x2 = 2
x3 = 3

p1 = 0.2
p2 = 0.6
p3 = 0.2

M = 10000
x = zeros(M)

x1bin = 0
x2bin = 0
x3bin = 0

for i=1:M
    global x1bin, x2bin, x3bin
    u = rand()
    if u < p1
        x[i] = x1
        x1bin += 1
    elseif p1 <= u < (p1+p2)
        x[i] = x2
        x2bin += 1
    else
        x[i] = x3
        x3bin += 1
    end
end

print("Program ran succesfully")

fig1 = histogram(x)
display(fig1)
