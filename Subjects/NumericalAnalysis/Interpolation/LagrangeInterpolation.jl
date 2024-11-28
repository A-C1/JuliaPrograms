using LinearAlgebra
using GLMakie

# Implement Lagrange interpolation algorithm
# Given: x_co-ordinates : x_1, x_2, x_3, .... x_n, x_n+1
#        y_co-ordinates : y_1, y_2, y_3, .... y_n, y_n+1


xv = [2, 2.75, 4, 4.5, 5, 6]
f(x) = 1/x
yv =  f.(xv)

function lagrange_interp(x, xv, yv)
    n = length(xv)
    w = ones(n)
    for i in eachindex(w)
        for j=1:n
            if i != j
                w[i] = w[i]*(xv[i] - xv[j])
            end
        end
        w[i] = 1/w[i]
    end
    y = w .* yv 

    ind = (x .== xv)
    if any(ind)
        return yv[ind][1]
    else
        p = 0.0
        q = 0.0
        for i in eachindex(xv)
            p = p + y[i]/(x-xv[i])
            q = q + w[i]/(x-xv[i])
        end
        return p/q
    end
end


xp = collect(2:0.01:6)
yp = f.(xp) 
ypl = lagrange_interp.(xp, Ref(xv), Ref(yv))

fig1 = Figure()
ax = Axis(fig1[1,1])
lines!(ax, xp, yp)
lines!(ax, xp, ypl)
display(fig1)