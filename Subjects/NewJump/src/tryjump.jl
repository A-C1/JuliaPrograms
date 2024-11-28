using JuMP
import Ipopt
using GLMakie

dubins = Model(Ipopt.Optimizer)
# set_silent(dubins)

# Constants
vm = 1.0
um = 1.0        # Maximum thrust

n = 200    # Time steps
# Decision variables

@variables(dubins, begin
    0 <= Δt <= 0.05  # Time step
    ## State variables
    x[1:n]            # Velocity
    y[1:n]            # Height
    th[1:n]           # Height
    ## Control variables
    -um ≤ u[1:n] ≤ um    # Thrust
end)

# Least squares optimization
xref = 5
yref = 5
function obj(x, y)
    sum = zero(eltype(x))
    for i=1:length(x)
        sum = sum + (x[i] - xref)^2 + (y[i] - yref)^2
    end

    return sum
end
# Objective
@objective(dubins, Min, Δt)

# Initial conditions
# fix(x[1], 0; force = true)
# fix(y[1], 0; force = true)
# fix(Δt, 0.01; force = true)


@constraint(dubins, x[1] == 0)
@constraint(dubins, y[1] == 0)
@constraint(dubins, th[1] == -π/2)
# @constraint(dubins, Δt == 0.05)

# Final conditions
@constraint(dubins, x[n] == 5.0)
@constraint(dubins, y[n] == 5.0)

function f1(x,u)
    return vm*cos(x[3])
end

function f2(x,u)
    return vm*sin(x[3])
end

function f3(x,u)
    return u
end
function f(x, u)
    return [vm*cos(x[3]), vm*sin(x[3]), u]
end
# Dynamics



for j in 1:n-1
    # @constraint(dubins, x[j] == x[j - 1] + Δt *0.5* vm*(cos(th[j - 1])+cos(th[j])))
    # k11 = @expression(dubins, f1([x[j],y[j],th[j]], u[j]))
    # k21 = @expression(dubins, f2([x[j],y[j],th[j]], u[j]))
    # k31 = @expression(dubins, f3([x[j],y[j],th[j]], u[j]))
    k1 = f([x[j], y[j], th[j]], u[j])

    # k12 = @expression(dubins, f1([x[j] + Δt*k11/2, y[j] + Δt*k21/2, th[j] + Δt*k31/2], u[j]))
    # k22 = @expression(dubins, f2([x[j] + Δt*k11/2, y[j] + Δt*k21/2, th[j] + Δt*k31/2], u[j]))
    # k32 = @expression(dubins, f3([x[j] + Δt*k11/2, y[j] + Δt*k21/2, th[j] + Δt*k31/2], u[j]))
    k2 = f([x[j], y[j], th[j]] + Δt*k1/2, u[j])


    # k13 = @expression(dubins, f1([x[j] + Δt*k12/2, y[j] + Δt*k22/2, th[j] + Δt*k32/2], u[j]))
    # k23 = @expression(dubins, f2([x[j] + Δt*k12/2, y[j] + Δt*k22/2, th[j] + Δt*k32/2], u[j]))
    # k33 = @expression(dubins, f3([x[j] + Δt*k12/2, y[j] + Δt*k22/2, th[j] + Δt*k32/2], u[j]))
    k3 = f([x[j], y[j], th[j]] + Δt*k2/2, u[j])

    # k14 = @expression(dubins, f1([x[j] + Δt*k13, y[j] + Δt*k23, th[j] + Δt*k33], u[j]))
    # k24 = @expression(dubins, f2([x[j] + Δt*k13, y[j] + Δt*k23, th[j] + Δt*k33], u[j]))
    # k34 = @expression(dubins, f3([x[j] + Δt*k13, y[j] + Δt*k23, th[j] + Δt*k33], u[j]))
    k4 = f([x[j], y[j], th[j]] + Δt*k3, u[j])
    # @expression(dubins, k12, f1([x[j],y[j],th[j]], u[j]))
    # @expression(dubins, k13, f1([x[j],y[j],th[j]], u[j]))
    # @expression(dubins, k14, f1([x[j],y[j],th[j]], u[j]))
    # @constraint(dubins, x[j+1] == x[j] + Δt*( k11 + 2*k12 + 2*k13 + k14)/6)
    # # Trapezoidal integration
    # @constraint(dubins, y[j+1] == y[j] + Δt*(k21 + 2*k22 + 2*k23 + k24)/6)
    # # Trapezoidal integration
    # @constraint(dubins, th[j+1] == th[j] + Δt*(k31 + 2*k32 + 2*k33 + k34)/6)
    # Trapezoidal integration
    @constraint(dubins, x[j+1] == x[j] + Δt*( k1[1] + 2*k2[1] + 2*k3[1] + k4[1])/6)
    # Trapezoidal integration
    @constraint(dubins, y[j+1] == y[j] + Δt*(k1[2] + 2*k2[2] + 2*k3[2] + k4[2])/6)
    # Trapezoidal integration
    @constraint(dubins, th[j+1] == th[j] + Δt*(k1[3] + 2*k2[3] + 2*k3[3] + k4[3])/6)
end

# Solve for the control and state
println("Solving...")
optimize!(dubins)
solution_summary(dubins)

# Display results

println("Min time: ", objective_value(dubins)*n)

fig = Figure()
ax = Axis(fig[1,1], autolimitaspect = 1)
lines!(ax, value.(x), value.(y))
# ax.autolimitaspect = 1
fig