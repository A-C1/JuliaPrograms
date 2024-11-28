using JuMP
import Ipopt
import Plots

# Create JuMP model, using Ipopt as the solver
user_options = (
    # "mu_strategy" => "monotone",
    # "linear_solver" => "ma27",
)
dubins = Model(optimizer_with_attributes(Ipopt.Optimizer,user_options...))
# set_silent(dubins)

# Constants
vm = 1.0
um = 1.0        # Maximum thrust

n = 200    # Time steps
tmin = (2*pi*1)/vm
tmax = 100
# Decision variables

@variables(dubins, begin
    (tmin)/n <= Δt <= (tmax)/n  # Time step
    ## State variables
    x[1:3, 1:n]            # Velocity
    ## Control variables
    -um ≤ u[1:n] ≤ um    # Thrust
end)

## Objective
@objective(dubins, Min, Δt)

## Initial conditions
fix(x[1,1], 0; force = true)
fix(x[2,1], 0; force = true)
fix(x[3,1], 0; force = true)

## Final conditions
fix(x[1, n], 10.0; force = true)
fix(x[2, n], 10.0; force = true)
fix(x[3, n], pi/2; force = true)

@NLexpression(model, cos(x[3]))
function dyn1(x, u)
	xdot = @NLexpression(model, cos(x[3]))
	ydot = @NLexpression(model, sin(x[3]))
	tdot = @NLexpression(model, u))
	return [xdot, ydot, tdot]
end

function rk4(x, u, h)
	k1 = dynamics(x, u)
	k2 = dynamics(x + k1/2, u)
	k3 = dynamics(x + k2/2, u)
	k4 = dynamics(x + k3, u)

	return h*(k1 + 2*k2 + 2*k3 + k4)/6
end

## Dynamics

for i in 2:n
	for j = 1:3
		for k = 1:4
    		@NLconstraint(dubins, x[k,j] == x[k,j-1] + rk4(x[:,j-1], u[j-1], Δt)[k] )
		end
	end
end

# Solve for the control and state
println("Solving...")
optimize!(dubins)
solution_summary(dubins)

# ## Display results

println("Min time: ", objective_value(dubins)*n)


Plots.plot(value.(x[1,:]), value.(y[1,:]), legend = false, aspect_ratio=:equal)