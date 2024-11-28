using JuMP
import Ipopt

mwe = Model(Ipopt.Optimizer)

@variable(mwe, x[1:5])
@variable(mwe, y[1:5])

xref = ones(5)*10
yref = ones(5)*20

function obj(x, y, xref, yref)
    sum = zero(eltype(x))
    for i=1:length(xref)
        sum = sum + (x[i] - xref[i])^2 + (y[i] - yref[i])^2
    end

    return [sum, sum]
end

@objective(mwe, Min, obj(x[1:5], y[1:5], xref, yref)[1])

optimize!(mwe)

println("Value of x and y : ", [value.(x) value.(y)])