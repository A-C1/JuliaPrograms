using GLMakie

xv = [1.0, 2.0, 4.0]
yv = [1.0, 3.0, 3.0]

xv = [2, 2.75, 4]
f(x) = 1/x
yv =  f.(xv)

n = length(xv)
A = Matrix{Float64}(undef, n, n)

# Write divided differences with custom data type


function divided_differences!(x, xv, yv, A)
    n = length(xv)
    for i = 1:n
        for j = i:n
            if i == 1
                A[j, i] = yv[j]
            else
                A[j, i] = -(A[j-1, i-1] - A[j, i-1]) / (xv[j] - xv[j-(i-1)])
            end
        end
    end
    
    
    y = 0.0
    c = 1.0
    for i=1:n
        y = y + A[i, i]*c 
        c = c*(x - xv[i])
    end

    return y
end

xp = collect(2:0.01:4)
yp = f.(xp) 
ypl = divided_differences!.(xp, Ref(xv), Ref(yv), Ref(A))

fig1 = Figure()
ax = Axis(fig1[1, 1])
lines!(ax, xp, yp)
lines!(ax, xp, ypl)

data = Dict(8.3 => (17.564921, 3.116256, 0.120482), 8.6 => (18.505155, 3.151762))
data1 = Dict("x1" => (8.3 ,(17.564921, 3.116256, 0.120482)), "x2" => (8.6, (18.505155, 3.151762)))

dataX = collect(keys(data))
dataY = collect(values(data))
q = size(dataX, 1);
m = zeros(Int64, q)
sum = 0
for i = 1:q
    m[i] = length(dataY[i])
    global sum = sum + m[i]
end

A = zeros(sum, sum+1)
ind = 1
for i = 1:q
    for j = 1:m[i]
        A[ind, 1] = dataX[i]
        A[ind, 2] = dataY[i][1]
        global ind = ind + 1
    end
end

for j = 3:size(A,2)
    for i = j-1:size(A,1) 
        A[i, j] = (A[i,j-1] - A[i-1,j-1]) / (A[i,1] - A[i-1,1])
    end
end


function hermitecoeffs(data::Dict)
    dataX = collect(keys(data))
    dataY = collect(values(data))
    q = size(dataX);
    m = size()

    c = dataX[1]

    return c
end

# c = hermitecoeffs(data)

