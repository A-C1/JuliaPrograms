# -*- coding: utf-8 -*-
"""
Created on Wed Mar  7 11:13:12 2018

@author: Aditya Chaudhari
email: aditya2192@gmail.com

All the functions are defined in the
file tangfunc_const
"""

import numpy as np
import matplotlib.pyplot as plt
import tangfunc_const as tang

# Initial states, parameters and dynamics of the pursuer
vp = 2.
up = 2.
z0p = [0., 0, np.pi/2]

def pur_dyn(x, u):
    return np.array([vp*np.cos(x[2]), vp*np.sin(x[2]), vp*u])

# Initial states, parameters and dynamics of the evader
ve = 1.
ue = 1.
z0e = [0, -6, np.pi/2]

def eva_dyn(x, u):
    return np.array([ve*np.cos(x[2]), ve*np.sin(x[2]), ve*u])

# Simulation parameters
dt = 0.001    # Step size
tf = 100      # Final time
no_iter = np.int(tf/dt)   # Total number of iterations
no_iter_mark = no_iter    # Stores the iteration at which convergence occures

states_p = np.zeros([no_iter, 3])  # Stores pursuers state
states_e = np.zeros([no_iter, 3])  # Stores evaders state
inputs1 = np.zeros([no_iter, 2])   # Stores inputs
inputs2 = np.zeros([no_iter, 2])   # Stores inputs
matrix = np.zeros([2, 2, no_iter]) # Stores the min-max matrix at each instant 
time = np.zeros([no_iter])         # Stores the current time


states_p[0, :] = z0p   # Store the initial state of pursuer
states_e[0, :] = z0e   # Store the initial state of evader

for i in range(0, no_iter-1):
    # Calculate the inputs using Line of sight law
    # [up_t1, ue_t1] = tang.calc_input_los(vp, up, states_p[i, :],
                                         # ve, ue, states_e[i, :])

    # This line implements the input
    # Calculate the inputs by using tangent law
    [up_t, ue_t, matrix[:, :, i]] = tang.calc_input(vp, up, states_p[i, :],
                                                    ve, ue, states_e[i, :])

    inputs2[i, :] = [up_t, ue_t]   # Store the inputs 

    # Update and store the states
    states_p[i+1, :] = states_p[i, :] + pur_dyn(states_p[i, :], up_t*up)*dt
    states_e[i+1, :] = states_e[i, :] + eva_dyn(states_e[i, :], ue_t*ue)*dt


    # Fixing the pursuer and evader states in between 0 to 2\pi
    if states_p[i+1, 2] > np.pi*2:
        states_p[i+1, 2] -= 2*np.pi
    elif states_p[i+1, 2] < 0:
        states_p[i+1, 2] += 2*np.pi

    if states_e[i+1, 2] > np.pi*2:
        states_e[i+1, 2] -= 2*np.pi
    elif states_e[i+1, 2] < 0:
        states_e[i+1, 2] += 2*np.pi

    # update the time
    time[i+1] = time[i] + dt

    # Check convergence. If converged come out of loop
    if tang.calc_dist(states_e[i, 0], states_e[i, 1], states_p[i, 0],
                      states_p[i, 1]) < .1:
        no_iter_mark = i - 2
        print("Gotcha!!")
        break

print(time[i])   # Prints the time to capture



#****************************************************************************
#****************************************************************************
#****************************************************************************
## Plot of x-y
plt.plot(states_p[0:no_iter_mark, 0], states_p[0:no_iter_mark, 1],'b--', label = "Pursuer")
plt.plot(states_e[0:no_iter_mark, 0], states_e[0:no_iter_mark, 1], 'r-.', label = "Evader" )
plt.grid(True)
plt.axis('equal')
plt.xlabel('x-position')
plt.ylabel('y-position')
plt.title('x-y graph for pursuer and evader')
plt.legend(loc='upper left', frameon=False)
plt.show()
# plt.savefig('/home/aditya/Dropbox/Latex_Current_Projects/Game_Two_Cars/xy-plot4.png')


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






