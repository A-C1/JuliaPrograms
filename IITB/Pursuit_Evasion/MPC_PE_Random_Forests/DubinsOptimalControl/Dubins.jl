using JuMP
import Ipopt
using Plots
using LaTeXStrings

# Create JuMP model, using Ipopt as the solver
user_options = (
    # "mu_strategy" => "monotone",
    # "linear_solver" => "ma27",
)
dubins = Model(optimizer_with_attributes(Ipopt.Optimizer,user_options...))
#set_silent(dubins)

# Constants
vm = 1.0
um = 1.0        # Maximum thrust

x_f = 5.0
y_f = 5.0

n = 40    # Time steps
tmin = (2*pi*1)/vm
tmax = 100
# Decision variables

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

## Initial conditions
fix(x[1], 0; force = true)
fix(y[1], 0; force = true)
fix(th[1], 0; force = true)

## Final conditions
fix(x[n], x_f; force = true)
fix(y[n], y_f; force = true)
# fix(th[n], pi/2; force = true)


## Dynamics

for j in 2:n
    @NLconstraint(dubins, x[j] == x[j - 1] + Δt *0.5* vm*(cos(th[j - 1])+cos(th[j])))
    ## Trapezoidal integration
    @NLconstraint(dubins, y[j] == y[j - 1] + Δt *0.5* vm*(sin(th[j - 1])+sin(th[j])))
    ## Trapezoidal integration
    @NLconstraint(dubins, th[j] == th[j - 1] + 0.5*Δt * (u[j]+u[j-1]))
    ## Trapezoidal integration
end

# Solve for the control and state
println("Solving...")
optimize!(dubins)
solution_summary(dubins)

function plot_circle(xc, yc, rc, fig)
	th = collect(0:0.1:2π)
	plot!(fig, xc .+ rc*cos.(th), yc .+ rc*sin.(th), line =:dash, color =:red, label =nothing)
end
## Display results
println("Min time: ", objective_value(dubins)*n)
fig1 = plot(value.(x), value.(y), 
		# label = "Vehicle trajectory",
		legend = false,
		aspect_ratio=:equal, 
		framestyle =:box, lw = 2, fmt = :pdf)
plot_circle(0, 1.0, 1.0, fig1)
plot_circle(0, -1.0, 1.0, fig1)
xtik = collect(1:5)
xlabel!(fig1, L"$x-\textrm{position}$")
ylabel!(fig1, L"$y-\textrm{position}$")
plot!(fig1, [0.0, 0.4], [0.0, 0.0], color =:black,arrow=true, arrowsize=1, lw=2, label =nothing)
scatter!(fig1, [0], [0], color =:black, markersize = 5, label =  nothing)
scatter!(fig1, [x_f], [y_f], shape = :star5, label = nothing, markersize = 10)
annotate!(fig1, -2.0, -0.2, L"$\mathbf{z_0} = [0, 0]$")
annotate!(fig1, x_f-2.0, y_f-0.1, L"$\mathbf{z_f} = [%$x_f, %$y_f]$")

savefig(fig1, "DVNumericalFar.pdf")