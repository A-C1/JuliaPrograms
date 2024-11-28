import optimal
import numpy as np
import matplotlib.pyplot as plt

# **********************************************************
# Persuers Problem Data
N_p = 200         # No of steps

sys_dim_p = 6     # Dimension of the System
num_inputs_p = 3  # Number of inputs
psi_dim_p = 1     # Number of end point equality constraints

x_initial_p = [0, 0, 0, 5, 2.5, 5]  # Initial Conditions
x_final_p = ["rel", "rel", "rel"]  # Final State,"rel" if free
# First Write the limits of states and then that of inputs
# [x' u']
state_limits_L_p = [-50, -50, -50, -50, -50, -50, -6.28, -6.28. -6.28]  # Lower State limits
state_limits_U_p = [50, 50, 50, 50, 50, 50, 6.28, 6.28, 6.28]
time_limit_L_p = 0.0/N_p
time_limit_U_p = 100/N_p
new_dim_p = sys_dim_p + num_inputs_p


# Dynamics of System
def sys_dyn_p(x, delta_h):
    assert len(x) == new_dim_p
    return [x[0] + v*np.cos(x[6])*delta_h,
            x[1] + v*np.sin(x[6])*delta_h,
            x[2] + v*np.cos(x[7])*delta_h,
            x[3] + v*np.sin(x[7])*delta_h,
            x[4] + v*np.cos(x[8])*delta_h,
            x[5] + v*np.sin(x[8])*delta_h,


    # Derivative of system dynamics
# with respect to states and inputs
# [h,x(k),u(k),x_i(k+1)]
def sys_der_p(xk, delta_h):
    return(np.array([[-v*np.cos(xk[2]), -1, 0, delta_h*v*np.sin(xk[2]), 0, 1],
                     [-v*np.sin(xk[2]), 0, -1, -v*np.cos(xk[2])*delta_h, 0, 1],
                     [-xk[3], 0, 0, -1, -1*delta_h, 1]]))


    # Defining End point Constraints
def psi_p(xf, delta_t, extra_data_persuer):
    xe = extra_data_persuer[0]
    T_step = extra_data_persuer[1]
    N_p = extra_data_persuer[2]
    t_final_persuer = delta_t*N_p
    xe_tf = np.zeros([sys_dim_p])
    for i in range(0, sys_dim_p):
        xe_tf[i] = np.interp(t_final_persuer, T_step, xe[i][:])
    return [(xf[0]-xe_tf[0])**2 + (xf[1]-xe_tf[1])**2]


# Define Derivatives of psi with respect to state at end point
def psi_der_p(xf, delta_t, extra_data_persuer):
    xe = extra_data_persuer[0]
    T_step = extra_data_persuer[1]
    N_p = extra_data_persuer[2]
    t_final_persuer = delta_t*N_p
    xe_tf = np.zeros([sys_dim_p])
    for i in range(0, sys_dim_p):
        xe_tf[i] = np.interp(t_final_persuer, T_step, xe[i][:])
    return([[2*(xf[0]-xe_tf[0]), 2*(xf[1]-xe_tf[1]), 0]])


# Define the function under integral sign in objective function
def L_p(x, u, t, extra_data_persuer):
    return 1


# Derivative of L w.r.t x,u,x[0]
def L_der_p(x, u, t, extra_data_persuer):
    return(np.array([0, 0, 0, 0]))


# Define the final time function to be minimized called phi
def phi_p(xf, tf, extra_data_persuer):
    return ([0])


# Derivative of phi w.r.t. t,x
def phi_der_p(xf, tf, extra_data_persuer):
    return (np.array([0, 0, 0, 0]))


# Persuers Problem Ends here

# # ******************************************
# # Evaders Functions are defined over here
N_e = 200        # No of steps

sys_dim_e = 3     # Dimension of the System
num_inputs_e = 1  # Number of inputs
psi_dim_e = 0     # Number of end point equality constraints

x_initial_e = np.array([0.01, 0.01, -np.pi])  # Initial Conditions
x_final_e = ["rel", "rel", "rel"]  # Final State,"rel" if free
# First Write the limits of states and then that of inputs
# [x' u']
state_limits_L_e = [-20, -20, -6.4, -0.7]  # Lower State limits
state_limits_U_e = [20, 20, 6.4, 0.7]
new_dim_e = sys_dim_e + num_inputs_e


# Dynamics of System
def sys_dyn_e(x, delta_h):
    assert len(x) == new_dim_p
    v = 0.2  # Velocity of Dubins vehicle
    return ([x[0] + v*np.cos(x[2])*delta_h,
        x[1] + v*np.sin(x[2])*delta_h,
        x[2] + x[3]*delta_h])


    # Derivative of system dynamics
# with respect to states and inputs
# [h,x(k),u(k),x_i(k+1)]
def sys_der_e(xk, delta_h):
    v = 0.2  # Velocity of Dubins vehicle
    return(np.array([[-v*np.cos(xk[2]), -1, 0, delta_h*v*np.sin(xk[2]), 0, 1],
        [-v*np.sin(xk[2]), 0, -1, -v*np.cos(xk[2])*delta_h, 0, 1],
        [-xk[3], 0, 0, -1, -1*delta_h, 1]]))


    # Defining End point Constraints
def psi_e(xf, delta_t, extra_data_evader):
    return [0]


# # Define Derivatives of psi with respect to state at end point
def psi_der_e(xf, delta_t, extra_data_evader):
    return [0]


# # Define the function under integral sign in objective function
def L_e(x, u, t, extra_data_evader):
    return 0


# # Derivative of L w.r.t x,u,x[0]
def L_der_e(x, u, t, extra_data_evader):
    return(np.array([0, 0, 0, 0]))


# # Define the final time function to be minimized called phi
def phi_e(xf, tf, extra_data_evader):
    c = extra_data_evader[0]
    e0 = extra_data_evader[1]
    return [np.dot(-c, (xf-e0))]


# # Derivative of phi w.r.t. t, x
def phi_der_e(xf, tf, extra_data_evader):
    c = extra_data_evader[0]
    return (np.array([0, -c[0], -c[1], -c[2]]))


# Derivative of constrain l w.r.t evaders state
def l_der_e(x_p, x_e):
    return np.array([-2*(x_p[0]-x_e[0]), -2*(x_p[1]-x_e[1]), 0])


# Derivative of constrain l w.r.t evaders state
def l_der_p(x_p, x_e):
    return np.array([2*(x_p[0]-x_e[0]), 2*(x_p[1]-x_e[1]), 0])


def evader_dyn(xe, u):
    return np.array([0.1*np.cos(xe[2]), 0.1*np.sin(xe[2]), u])


def plot_pe(t, y, u):
    plt.grid()
    plt.plot(y[0], y[1])
    return 0


T = 50
T_step = np.linspace(0, T, N_e)  # Time division array foe evader
dw = T/N_e  # Length of discrete time interval for evader
xe_g = np.zeros([sys_dim_e, N_e])
xe_g[:, 0] = x_initial_e.T
for i in range(0, N_e-1):
    xe_g[:, i+1] = xe_g[:, i] + evader_dyn(xe_g[:, i], 0)*dw

# First Iteration of Evaders Problem
# Extra data to be passedto the function
for i in range(0, 10):
    extra_data_persuer = [xe_g, T_step, N_p]
    status = 1 
    while(status !=0):
        [lambdas, states, inputs, time, obj, status] = \
                optimal.time_opt(sys_dyn_p, sys_der_p, sys_dim_p, num_inputs_p,
                        psi_p, psi_der_p, psi_dim_p, phi_p, phi_der_p,
                        L_p, L_der_p, x_initial_p, x_final_p,
                        state_limits_L_p, state_limits_U_p,
                        time_limit_L_p, time_limit_U_p,
                        N_p, extra_data_persuer)


    plt.figure(i+1)
    plt.grid()
    plt.plot(xe_g[0], xe_g[1])
    plt.plot(states[0], states[1], '--')

    t_inter = obj  # Time at which the pursuer catches the evader
    time_limit_L_e = t_inter/N_e  # Fixed time for evader
    time_limit_U_e = t_inter/N_e  # Fixed time for evader

    xp_cap = states[:, -1]  # State at the evader at the time of capture
    xe_cap = np.zeros([sys_dim_e]) # State of evader at time of capture
    for i in range(0, sys_dim_p):
        xe_cap[i] = np.interp(t_inter, T_step, xe_g[i][:])

    alpha1 = lambdas[-1]
    l_tf = l_der_e(xp_cap, xe_cap)
    c = 0.2*alpha1*l_tf

    extra_data_evader = [c, xe_cap]

    status_e = 1
    while(status_e != 0):
        [lambdas_e, xe_g, inputs_e, time_e, obj_e, status_e] = \
                optimal.time_opt(sys_dyn_e, sys_der_e, sys_dim_e, num_inputs_e,
                        psi_e, psi_der_e, psi_dim_e, phi_e, phi_der_e,
                        L_e, L_der_e, x_initial_e, x_final_e,
                        state_limits_L_e, state_limits_U_e,
                        time_limit_L_e, time_limit_U_e, N_e,
                        extra_data_evader)

    print(status_e)

    T_step = np.linspace(0, obj, N_e)

plt.show()

