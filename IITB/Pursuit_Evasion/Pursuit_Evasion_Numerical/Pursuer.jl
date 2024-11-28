module Pursuer
# # Dubins Car Time Optimal Control using JuMP
using JuMP
import Ipopt
using Plots

# Create JuMP model, using Ipopt as the solver

function pursuer_problem(xf = [10, 10])
    dubins = Model(Ipopt.Optimizer)
    set_silent(dubins)
    n = 800    # Time steps

    # Constants
    u_max = 1  # Maximum Angular Input

    # Decision variables

    @variables(dubins, begin
        Δt ≥ 0, (start = 1 / n) # Time step
        # State variables
        x[1:n]           # x-coordinate
        y[1:n]           # y-coordinate
        θ[1:n]           # Orientation
        # Control variables
        -u_max ≤ u[1:n] ≤ u_max    # Thrust
    end)

    # Objective
    @objective(dubins, Min, Δt)

    # Initial conditions
    fix(x[1], 0; force = true)
    fix(y[1], 0; force = true)
    fix(θ[1], 0; force = true)


    # Dynamics
    for j in 2:n
        # x' = cos(θ)
        @NLconstraint(dubins, x[j] == x[j-1] + Δt * cos(θ[j-1]))
        # y' = sin(θ)
        @NLconstraint(dubins, y[j] == y[j-1] + Δt * sin(θ[j-1]))
        # θ' = u
        @NLconstraint(dubins, θ[j] == θ[j-1] + Δt * u[j-1])
    end

    # Final time constraints
    @NLconstraint(dubins, x[n] == xf[1])
    @NLconstraint(dubins, y[n] == xf[2])

    # Solve for the control and state
    println("Solving...")
    optimize!(dubins)
    solution_summary(dubins)

    # Display results
    println("Time required: ", n * objective_value(dubins))
    return value.(x), value.(y)
end

x_val, y_val = pursuer_problem([10, 10])
plot(x_val, y_val)

end