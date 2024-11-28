# Dubins Car Time Optimal Control using JuMP
using JuMP
import Ipopt
import Plots

# Create JuMP model, using Ipopt as the solver
dubins = Model(Ipopt.Optimizer)
n = 100    # Time steps

# Dubins vehicle parameters
u_max = 0.3  # Maximum Angular Input

# Decision variables
@variables(dubins, begin
    Δt ≥ 0  # Time step
    # State variables
    x[1:n]           # x-coordinate
    y[1:n]           # y-coordinate
    θ[1:n]           # Orientation
    # Control variables
    -u_max ≤ u[1:n] ≤ u_max    # Thrust
end)

# Objective: Minimize time
@objective(dubins, Min, Δt)

# Initial conditions
@NLconstraint(dubins, x[1] == 0.0)
@NLconstraint(dubins, y[1] == 0.0)
@NLconstraint(dubins, θ[1] == 0.0)


# Constraints for satisfying Dynamics
for j in 2:n
    # x' = cos(θ)
    @NLconstraint(dubins, x[j] == x[j-1] + Δt * (cos(θ[j-1]) + cos(θ[j])) / 2)
    # y' = sin(θ)
    @NLconstraint(dubins, y[j] == y[j-1] + Δt * (sin(θ[j-1]) + sin(θ[j])) / 2)
    # θ' = u
    @NLconstraint(dubins, θ[j] == θ[j-1] + Δt * (u[j-1] + u[j]) / 2)
end

# Constraints for not passing through circles
rc = 1.0
xc = 5.0
yc = [5 + 0.5 * i for i = 1:5]
for i = 1:n
    @NLconstraint(dubins, (x[i] - xc)^2 + (y[i] - yc[1])^2 ≥ rc^2)
    @NLconstraint(dubins, (x[i] - xc)^2 + (y[i] - yc[2])^2 ≥ rc^2)
    @NLconstraint(dubins, (x[i] - xc)^2 + (y[i] - yc[3])^2 ≥ rc^2)
    @NLconstraint(dubins, (x[i] - xc)^2 + (y[i] - yc[4])^2 ≥ rc^2)
    @NLconstraint(dubins, (x[i] - xc)^2 + (y[i] - yc[5])^2 ≥ rc^2)
end


# Final time constraints
xf = 7.0
yf = 8.0
@NLconstraint(dubins, (x[n] - xf)^2 + (y[n] - yf)^2 ≤ 0.01)

# Solve for the control and state
println("Solving...")
optimize!(dubins)
# solution_summary(dubins)

# ## Display results

println("Time required: ", n * objective_value(dubins))
plt1 = Plots.plot(value.(x), value.(y), aspect_ratio = 1, legend = false, framestyle = :box)

# Circles
xt = zeros(n)
yt = zeros(n)
θt = LinRange(0, 2π, n)
for j = 1:5
	global plt1
    for i = 1:n
        xt[i] = xc + rc * cos(θt[i])
        yt[i] = yc[j] + rc * sin(θt[i])
    end
    Plots.plot!(plt1, xt, yt)
end

# Plotting final and initial locations
Plots.scatter!(plt1, [0, xf], [0, yf])
Plots.savefig(plt1, "dubins_obstacle.png")
display(fig1)