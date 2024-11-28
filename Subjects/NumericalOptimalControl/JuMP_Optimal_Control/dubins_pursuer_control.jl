using JuMP
import Ipopt
using Plots
using Interpolations

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

# Evader trajectory
δt = 0.1
timeE = collect(0:0.1:12)
# xe = 4*ones(length(timeE))

function dubins_next_state(s, u, δt)
	sn = zeros(3)
	sn[1] = s[1] + 0.5*cos(s[3])*δt
	sn[2] = s[2] + 0.5*sin(s[3])*δt
	sn[3] = s[3] + 0.5*u*δt
	return sn
end

xe = zeros(3, length(timeE))
xe[:,1] = [4,4,0]
for i=1:(length(timeE)-1)
	global xe, δt
	xe[:, i+1] = dubins_next_state(xe[:,i], 0,δt )
end

function xval(Δt)
	global δt, timeE, xe, n
	interp = LinearInterpolation(timeE, xe[1,:])
	return interp(n*Δt)
end
register(dubins,:xval, 1, xval; autodiff = true)

function yval(Δt)
	global δt, timeE, xe, n
	interp = LinearInterpolation(timeE, xe[2,:])
	return interp(n*Δt)
end
register(dubins,:yval, 1, yval; autodiff = true)

@variables(dubins, begin
    (tmin)/n <= Δt <= (tmax)/n  # Time step
    ## State variables
    x[1:n]            # Velocity
    y[1:n]            # Height
    th[1:n]           # Height
    ## Control variables
    -um ≤ u[1:n] ≤ um    # Thrust
end)

# Objective
@objective(dubins, Min, Δt)

# Initial conditions
fix(x[1], 0; force = true)
fix(y[1], 0; force = true)
fix(th[1], 0; force = true)

# Final conditions
@NLconstraint(dubins, x[n] == xval(Δt))
@NLconstraint(dubins, y[n] == yval(Δt))

# Dynamics
for j in 2:n
    @NLconstraint(dubins, x[j] == x[j - 1] + Δt *0.5* vm*(cos(th[j - 1])+cos(th[j])))
    # Trapezoidal integration
    @NLconstraint(dubins, y[j] == y[j - 1] + Δt *0.5* vm*(sin(th[j - 1])+sin(th[j])))
    # Trapezoidal integration
    @NLconstraint(dubins, th[j] == th[j - 1] + 0.5*Δt * (u[j]+u[j-1]))
    # Trapezoidal integration
end

# Solve for the control and state
println("Solving...")
optimize!(dubins)
solution_summary(dubins)

# Display results

println("Min time: ", objective_value(dubins)*n)


fig1 = plot(value.(x), value.(y), legend = false, aspect_ratio=:equal)
plot!(fig1, xe[1,:], xe[2,:])