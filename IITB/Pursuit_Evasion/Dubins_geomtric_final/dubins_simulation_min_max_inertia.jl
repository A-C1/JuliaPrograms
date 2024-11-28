#include("./Tangfunc")
using .Tangfunc
using LinearAlgebra, CairoMakie

ns = 4
nu = 2

# Initial states, parameters and dynamics of the pursuer
vp = 2.
up = 2.
ap = 2.2
z0p = [0.; 0; pi/2; 0]
rp = 1.0/up

function pur_dyn(x, u, a)
    return [x[4]*cos(x[3]); x[4]*sin(x[3]); x[4]*u; a]
end

# Initial states, parameters and dynamics of the evader
ve = 1.
ue = 1.
ae = 1.0
target_state = z0e = [10.; 10.; -pi/2; 0.]
re = 1.0/ue
#z0e = [10, 10, np.pi/4]



function eva_dyn(x, u, a)
    return [x[4]*cos(x[3]); x[4]*sin(x[3]); x[4]*u; a]
end

# Simulation parameters
dt = 0.001    # Step size
tf = 50      # Final time
no_iter = Int(tf/dt)   # Total number of iterations
no_iter_mark = no_iter    # Stores the iteration at which convergence occures

states_p = zeros(no_iter, ns)  # Stores pursuers state
states_e = zeros(no_iter, ns)  # Stores evaders state
inputs1 = zeros(no_iter, nu)   # Stores inputs
inputs2 = zeros(no_iter, nu)   # Stores inputs
matrix = zeros(2, 2, no_iter) # Stores the min-max matrix at each instant
time = zeros(no_iter)         # Stores the current time


states_p[1, :] = z0p   # Store the initial state of pursuer
states_e[1, :] = z0e   # Store the initial state of evader

currentDist = Tangfunc.calc_dist(z0e[1], z0e[2], z0p[1],
                      z0p[2])
threshhold = 2*re + 2*pi*re*(vp/ve)
for i=1:no_iter-1
    distance_pe = Tangfunc.calc_dist(states_e[i, 1], states_e[i, 2], states_p[i, 1],
                  states_p[i, 2])
    # Calculate the inputs using Line of sight law
    # [up_t1, ue_t1] = tang.calc_input_los(vp, up, states_p[i, :],
    #                                      ve, ue, states_e[i, :])

    # # Calculate the inputs by using tangent law
    (up_t, ue_t, matrix[:, :, i]) = Tangfunc.calc_input(vp, up, states_p[i, :],
                                                        ve, ue, states_e[i, :])
    # if time[i] < 9 and time[i] > 6:
    #     ue_t = 1
    # elif time[i]>=9:
    #     ue_t = 0
    # else
    #     (up_t, ue_t) = Tangfunc.calc_input_los(vp, up, states_p[i, :],
    #                                         ve, ue, states_e[i, :])
    # end

    inputs2[i, :] = [up_t ue_t]   # Store the inputs

    # Update and store the states
    states_p[i+1, :] = states_p[i, :] + pur_dyn(states_p[i, :], up_t*up, ap)*dt
    states_e[i+1, :] = states_e[i, :] + eva_dyn(states_e[i, :], ue_t*ue, ae)*dt

    # # Fixing the pursuer and evader velocity
    if states_p[i+1, 3] >= vp
        states_p[i+1, 3] = vp
	elseif states_p[i+1, 3] <= 0
        states_p[i+1, 3] = 0
	end

    if states_e[i+1, 3] >= ve
        states_e[i+1, 3] = ve
	elseif states_e[i+1, 3] <= 0
        states_e[i+1, 3] = 0
	end

    # Fixing the pursuer and evader states in between 0 to 2\pi
    if states_p[i+1, 3] > pi*2
        states_p[i+1, 3] -= 2*pi
    elseif states_p[i+1, 3] < 0
        states_p[i+1, 3] += 2*pi
    end

    if states_e[i+1, 3] > pi*2
        states_e[i+1, 3] -= 2*pi
    elseif states_e[i+1, 3] < 0
        states_e[i+1, 3] += 2*pi
    end

    # update the time
    time[i+1] = time[i] + dt
    global currentDist = Tangfunc.calc_dist(states_e[i, 1], states_e[i,2], states_p[i, 1],
                      states_p[i, 2])

    # Check convergence. If converged come out of loop
    if currentDist < .1
        global no_iter_mark = i 
        print("Gotcha!!")
        break
    end
    # if currentDist < (re-rp)
    #     global no_iter_mark = i 
    #     print("Gotcha!!")
    #     break
    # end
end

println(time[no_iter_mark])   # Prints the time to capture




#****************************************************************************
#****************************************************************************
#****************************************************************************
## Plot of x-y
f = Figure()
ax = Axis(f[1, 1], autolimitaspect = 1)
lines!(ax, states_p[1:no_iter_mark, 1], states_p[1:no_iter_mark, 2])
lines!(ax, states_e[1:no_iter_mark, 1], states_e[1:no_iter_mark, 2])


#****************************************************************************
#****************************************************************************
#****************************************************************************
## Prints the data to the text file

# np.savetxt("./data_los_puruser.csv", (states_e[0:no_iter_mark,0],
#     states_e[0:no_iter_mark,1]), delimiter=',')
# np.savetxt("./data_los_evader.csv", (states_p[0:no_iter_mark,0],
#     states_p[0:no_iter_mark,1]), delimiter=',')


#****************************************************************************
#****************************************************************************
#****************************************************************************
## Plotting the reachable sets
## Commented as not necessary

# T_final = time[no_iter_mark-3]

# t1p = 2*np.pi/(up*vp)
# no_iter_p = np.int(t1p/dt)
# tang.plot_reach(z0p, vp, up, 1, 1, 0, 0, 0, no_iter_p, T_final, dt)
# plt.axis('equal')
# plt.grid(True)


# t1e = 2*np.pi/(ue*ve)
# no_iter_e = np.int(t1e/dt)
# tang.plot_reach(z0e, ve, ue, 1, 1, 1, 0, 0, no_iter_e, T_final, dt)
# plt.axis('equal')
# plt.grid(True)

#****************************************************************************
#****************************************************************************
#****************************************************************************
## Animating the simulation. Currently not working

# x_lim = plt.xlim()
# y_lim = plt.ylim()
# axes_limits = [x_lim[0]-1, x_lim[1]+1, y_lim[0]-1, y_lim[1]+1]
# tang.anime(states_e[0:no_iter_mark, 0], states_e[0:no_iter_mark, 1],
#           states_e[0:no_iter_mark, 2],
#           states_p[0:no_iter_mark, 0], states_p[0:no_iter_mark, 1],
#           states_p[0:no_iter_mark, 2], dt, axes_limits)
# plt.show()
