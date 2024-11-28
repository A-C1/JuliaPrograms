using JuMP
import Ipopt
using GLMakie


vm = 1.0   # Max forward speed
um = 1.0   # Max turning speed
ns = 3     # Number of states
nu = 1     # Number of inputs
n = 200    # Time steps
x0 = [0, 0, -π / 2]
xf = [5.0, 5.0, π / 2 + π / 4]

p = (xfref=xf, x0=x0, vm = vm)
# System dynamics
function dyn(x, u, p)
    vm = p.vm
    return [vm * cos(x[3]), vm * sin(x[3]), u]
end

# Objective Function
# Running cost
function L(x, u, Δt, p)
    return 1.0
end
function phi(xf, uf, Δt, p)
    return 0.0
end
function psi(xf, uf, Δt, p)
    return xf - p.xfref
end

mutable struct OptCon2
    # Optimal control functions
    L::Function
    phi::Function
    psi::Function
    dyn::Function

    # Dimensions of various things
    n::Int64    # Number of finite elements
    ns::Int64   # State dim
    nu::Int64   # Input dim

    # Initial state
    x0::Vector{Float64}

    # Additional parameters to be stored
    p::NamedTuple

    function OptCon2()
        return new()
    end
end

OptCon = OptCon2

OC = OptCon2()

OC.L = L
OC.phi = phi
OC.psi = psi
OC.dyn = dyn

OC.n = n
OC.ns = ns
OC.nu = nu

OC.x0 = x0
OC.p = p


function obj_f(x, u, Δt, L, phi, n, ns, nu, p)
    sum = zero(eltype(x))
    for i = 1:n
        sum = sum + L(x[1:ns, i], u[1:nu, i], Δt, p) * Δt
    end
    sum = sum + phi(x[1:ns, n], u[1:nu, n], Δt, p)
    return sum
end

function solve(OC)
    (;L, phi, psi, dyn, n, ns, nu, x0, p) = OC

    oc = Model(Ipopt.Optimizer)

    # Decision variables
    @variables(oc, begin
        0 <= Δt <= 0.05  # Time step
        # State variables
        x[1:ns, 1:n]               # Velocity
        # Control variables
        -um ≤ u[1:nu, 1:n] ≤ um    # Thrust
    end)

    # Objective
    @objective(oc, Min, obj_f(x[1:ns, 1:n], u[1:nu, 1:n], Δt, L, phi, n, ns, nu, p))
    #Initial conditions
    @constraint(oc, x[1:ns, 1] .== x0)
    # Final conditions
    @constraint(oc, psi(x[1:ns, n], u[1:nu, n], Δt, p) == 0)

    # Dynamic constraints: RK4
    for j in 1:n-1
        k1 = f(x[1:ns, j], u[j], p)
        k2 = f(x[1:ns, j] + Δt * k1 / 2, u[j], p)
        k3 = f(x[1:ns, j] + Δt * k2 / 2, u[j], p)
        k4 = f(x[1:ns, j] + Δt * k3, u[j], p)
        @constraint(oc, x[1:ns, j+1] == x[1:ns, j] + Δt * (k1 + 2 * k2 + 2 * k3 + k4) / 6)
    end

    # Solve for the control and state
    println("Solving...")
    optimize!(oc)
    solution_summary(oc)

    # Display results
    println("Min time: ", objective_value(oc))

    fig = Figure()
    ax = Axis(fig[1, 1], autolimitaspect=1)
    lines!(ax, value.(x[1, 1:n]), value.(x[2, 1:n]))

    return fig
end

fig = solve(OC)


