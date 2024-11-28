using JuMP
using GLMakie
using FastGaussQuadrature
import Ipopt

dubins = Model(Ipopt.Optimizer)

vm = 1.0   # Max forward speed
um = 1.0   # Max turning speed
ns = 3     # Number of states
nu = 1     # Number of inputs
n = 200    # Time steps
x0 = [0, 0, -π/2 ]
xf = [5.0, 5.0, π/2 + π/4]

nl = 4 # Order of Gauss lobatto method
x, w = gausslobatto(nl)

# # System dynamics
# function f(x, u)
#     return [vm*cos(x[3]), vm*sin(x[3]), u]
# end

# # Objective Function
# # Running cost
# function L(x, u)
#     return 1.0
# end
# function phi(xf, uf)
#    return 0.0
# end
# function psi(xf, uf, Δt, xfref)
#     return xf - xfref
# end
# function obj_f(x, u, Δt, L, phi, n , ns, nu)
#     sum = zero(eltype(x))
#     for i=1:n
#         sum = sum + L(x[1:ns,i], u[1:nu,i])*Δt
#     end
#     sum = sum + phi(x[1:ns, n], u[1:nu,n]) 
#     return sum
# end

# # Decision variables
# @variables(dubins, begin
#     0 <= Δt <= 0.05  # Time step
#     # State variables
#     x[1:ns,1:n]               # Velocity
#     # Control variables
#     -um ≤ u[1:nu,1:n] ≤ um    # Thrust
# end)

# # Objective
# @objective(dubins, Min, obj_f(x[1:ns,1:n], u[1:nu,1:n], Δt, L, phi, n, ns, nu))
# #Initial conditions
# @constraint(dubins, x[1:ns, 1] .== x0 )
# # Final conditions
# @constraint(dubins, psi(x[1:ns, n], u[1:nu, n], Δt, xf) == 0)

# # Dynamic constraints: gauss-lobato
# for j in 1:n-1
#     k1 = f(x[1:ns,j], u[j])
#     k2 = f(x[1:ns,j] + Δt*k1/2, u[j])
#     k3 = f(x[1:ns,j] + Δt*k2/2, u[j])
#     k4 = f(x[1:ns,j] + Δt*k3, u[j])
#     @constraint(dubins, x[1:ns, j+1] == x[1:ns,j] + Δt*(k1 + 2*k2 + 2*k3 + k4)/6)
# end

# # Solve for the control and state
# println("Solving...")
# optimize!(dubins)
# solution_summary(dubins)

# # Display results
# println("Min time: ", objective_value(dubins))

# fig = Figure()
# ax = Axis(fig[1,1], autolimitaspect = 1)
# lines!(ax, value.(x[1,1:n]), value.(x[2, 1:n]))
# fig