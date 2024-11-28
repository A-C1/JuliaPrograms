# using Plots
using GLMakie
# using LaTeXStrings 

include("Isotropic.jl")
# Pursuer parameters
ap = 2.
xp_0 = 0.
yp_0 = 0.
# vxp_0 = 0.25
# vyp_0 = -0.25
vxp_0 = 1.5
vyp_0 = 0.0
zp_0 = [xp_0, vxp_0, yp_0, vyp_0]

# Evader parameters
ae = 1.
xe_0 = 0.6
ye_0 = 0.6
# vxe_0 = 0.5
# vye_0 = 0.5
vxe_0 = 0.0
vye_0 = 0.0
ze_0 = [xe_0, vxe_0, ye_0, vye_0]

# Simulation parameters
dt = 0.001
tf = 4
no_iter = Int(floor(tf/dt))
no_iter_mark = no_iter

# Storing simulation data
states_p = zeros(no_iter, 4)
input_p = zeros(no_iter)

states_e = zeros(no_iter, 4)
input_e = zeros(no_iter)

time = zeros(no_iter)

states_p[1, :] = zp_0
states_e[1, :] = ze_0
j = 1
for i = 1:no_iter
    x_p = states_p[i,1]
    v_p = states_p[i,2]
    y_p = states_p[i,3]
    w_p = states_p[i,4]

    x_e = states_e[i,1]
    v_e = states_e[i,2]
    y_e = states_e[i,3]
    w_e = states_e[i,4]

#     if i .== 1
#         theta = solve_numerically(x_p, v_p, y_p, w_p, x_e, v_e, y_e, w_e)
#         up = theta[1]
#         ue = theta[2]
#         theta1 = solve_theta_roots(x_p, v_p, y_p, w_p, x_e, v_e, y_e, w_e)
#
#         j = j + 1000
#     end
    theta = solve_theta(x_p, v_p, y_p, w_p, x_e, v_e, y_e, w_e, ap, ae)
    up = theta
    ue = theta
    ue = pi/2
    ue = - 3*π/(4.6)

    input_p[i] = up
    states_p[i+1,:] = states_p[i,:] + dyn_p(v_p,w_p,up,ap)*dt

    input_e[i] = ue
    states_e[i+1,:] = states_e[i,:] + dyn_e(v_e,w_e,ue,ae)*dt

    time[i+1] = time[i] + dt
    distance = sqrt((states_p[i,1] - states_e[i,1])^2 + (states_p[i, 3] - states_e[i, 3])^2)
    if distance .<  0.01
        global no_iter_mark = i - 1
        global tf = (i+1)*dt
        # no_iter_mark = i - 1
        # tf = (i+1)*dt
        break
    end
end


## Plotting the reachable sets
th = 0:0.001:2*pi

xc_e = xe_0 + vxe_0*tf
yc_e = ye_0 + vye_0*tf
R_e = 0.5*ae*tf^2
xunit_e = R_e * cos.(th) .+ xc_e
yunit_e = R_e * sin.(th) .+ yc_e

xc_p = xp_0 + vxp_0*tf
yc_p = yp_0 + vyp_0*tf
R_p = 0.5*ap*tf^2
xunit_p = R_p * cos.(th) .+ xc_p
yunit_p = R_p * sin.(th) .+ yc_p



#  Figure 1 only plots the trajectories
f = Figure()
ax = Axis(f[1, 1], autolimitaspect = 1)
lines!(ax, xunit_e, yunit_e, label = L"$\textrm{Pursuer's \; reachable \; set}$")
# lines!(ax, xunit_p, yunit_p, label = L"$\textrm{Pursuer's \; reachable \; set}$")
# lines!(ax, states_p[1:no_iter_mark,1], states_p[1:no_iter_mark,3], color=:red, ls=:dash, lw=2, label=L"$\textrm{Pursuer's \; trajectory}$" )
# lines!(ax, states_e[1:no_iter_mark,1], states_e[1:no_iter_mark,3], color=:blue, ls=:dash, lw=2, label=L"$\textrm{Evader's \; trajectory}$")
# x_e0 = states_e[1,1]
# y_e0 = states_e[1,3]
# x_p0 = states_p[1,1]
# y_p0 = states_p[1,3]
# scatter!(ax, x_e0, y_e0)
# scatter!(ax, [x_p0], [y_p0], label=nothing)
# scatter!(ax, [states_p[no_iter_mark,1]], [states_p[no_iter_mark,3]], markershape = :star, markersize = 10, label=nothing)
# xlabel!(ax, L"$x-\textrm{position}$")
# ylabel!(ax, L"$y-\textrm{position}$")
# annotate!(fig1, x_p0 - 0.5, y_p0 - 1.2, L"$\bf{P}$")
# annotate!(fig1, x_e0 - 0.5, y_e0 - 1.2, L"$\bf{E}$")
axislegend(ax)
display(f)

# fig1 = plot(aspect_ratio=1, frame_style=:box, lw=2, legend = :topleft)
# plot!(xunit_e, yunit_e, label = L"$\textrm{Evader's \; reachable \; set}$")
# plot!(xunit_p, yunit_p, label = L"$\textrm{Pursuer's \; reachable \; set}$")
# plot!(states_p[1:no_iter_mark,1], states_p[1:no_iter_mark,3], color=:red, ls=:dash, lw=2, label=L"$\textrm{Pursuer's \; trajectory}$" )
# plot!(states_e[1:no_iter_mark,1], states_e[1:no_iter_mark,3], color=:blue, ls=:dash, lw=2, label=L"$\textrm{Evader's \; trajectory}$")
# x_e0 = states_e[1,1]
# y_e0 = states_e[1,3]
# x_p0 = states_p[1,1]
# y_p0 = states_p[1,3]
# scatter!(fig1, [x_e0], [y_e0], label=nothing)
# scatter!(fig1, [x_p0], [y_p0], label=nothing)
# scatter!(fig1, [states_p[no_iter_mark,1]], [states_p[no_iter_mark,3]], markershape = :star, markersize = 10, label=nothing)
# xlabel!(fig1, L"$x-\textrm{position}$")
# ylabel!(fig1, L"$y-\textrm{position}$")
# annotate!(fig1, x_p0 - 0.5, y_p0 - 1.2, L"$\bf{P}$")
# annotate!(fig1, x_e0 - 0.5, y_e0 - 1.2, L"$\bf{E}$")