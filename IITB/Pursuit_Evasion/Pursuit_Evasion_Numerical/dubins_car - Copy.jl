## Dubins Car Time Optimal Control using JuMP
using JuMP
import Ipopt
import Plots

# Create JuMP model, using Ipopt as the solver

dubins = Model(Ipopt.Optimizer)
set_silent(dubins)

# ## Constants

# Note that all parameters in the model have been normalized
# to be dimensionless. See the COPS3 paper for more info.

u_max = 1  # Maximum Angular Input
n = 800    # Time steps

# Decision variables

@variables(dubins, begin
    Δt ≥ 0, (start = 1/n) # Time step
    ## State variables
    x[1:n]           # x-coordinate
    y[1:n]           # y-coordinate
    θ[1:n]           # Orientation
    ## Control variables
    -u_max ≤ u[1:n] ≤ u_max    # Thrust
end)

# ## Objective

# The objective is to maximize altitude at end of time of flight.

@objective(dubins, Min, Δt)

# ## Initial conditions

fix(x[1], 0; force = true)
fix(y[1], 0; force = true)
fix(θ[1], 0; force = true)


# ## Dynamics
for j in 2:n
    ## x' = cos(θ)
    ## Rectangular integration
    @NLconstraint(dubins, x[j] == x[j-1] + Δt*cos(θ[j-1]))
    ## y' = sin(θ)
    ## Rectangular integration
    @NLconstraint(dubins, y[j] == y[j-1] + Δt*sin(θ[j-1]))
    ## θ' = u
    ## Rectangular integration
    @NLconstraint(dubins, θ[j] == θ[j-1] + Δt*u[j-1])
end

# Final time constraints
@NLconstraint(dubins, x[n] == 10)
@NLconstraint(dubins, y[n] == 10)
@NLconstraint(dubins, θ[n] == 1.57/2)


# Solve for the control and state
println("Solving...")
optimize!(dubins)
solution_summary(dubins)

# ## Display results

println("Time required: ", n*objective_value(dubins))
Plots.plot(value.(x), value.(y))

#-

# function my_plot(y, ylabel)
#     return Plots.plot(
#         (1:n) * value.(Δt),
#         value.(y)[:];
#         xlabel = "Time (s)",
#         ylabel = ylabel,
#     )
# end

# Plots.plot(
#     my_plot(x, "Altitud"),
#     my_plot(m, "Mass"),
#     my_plot(v, "Velocity"),
#     my_plot(T, "Thrust");
#     layout = (2, 2),
#     legend = false,
#     margin = 1Plots.cm,
# )