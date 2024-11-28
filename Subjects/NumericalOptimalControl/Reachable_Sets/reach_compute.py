import optimal
import numpy as np
import matplotlib.pyplot as plt
import openpyxl

# **********************************************************
# Persuers Problem Data
N_p = 200       # No of steps

sys_dim_p = 3     # Dimension of the System
num_inputs_p = 1  # Number of inputs
psi_dim_p = 2     # Number of end point equality constraints

mul = 1/2  # Just for convinience of setting initial condition
x_initial_p = [0, 0, np.pi*mul]  # Initial Conditions
x_final_p = ["rel", "rel", "rel"]  # Final State,"rel" if free
# First Write the limits of states and then that of inputs
# [x' u']
state_limits_L_p = [-100, -100, 0, -1.5]  # Lower State limits
state_limits_U_p = [100, 100, 6.3, 1.5]
time_limit_L_p = 0
# time_limit_U_p = 10/N_p
time_limit_U_p = 3
new_dim_p = sys_dim_p + num_inputs_p


# Dynamics of System
def sys_dyn_p(x, delta_h):
    assert len(x) == new_dim_p
    v = 1  # Velocity of Dubins vehicle
    return ([x[0] + v*np.cos(x[2])*delta_h,
             x[1] + v*np.sin(x[2])*delta_h,
             x[2] + x[3]*delta_h])


# Derivative of system dynamics
# with respect to states and inputs
# [h,x(k),u(k),x_i(k+1)]
def sys_der_p(xk, delta_h):
    v = 1  # Velocity of Dubins vehicle
    return(np.array([[-v*np.cos(xk[2]), -1, 0, delta_h*v*np.sin(xk[2]), 0, 1],
                     [-v*np.sin(xk[2]), 0, -1, -v*np.cos(xk[2])*delta_h, 0, 1],
                     [-xk[3], 0, 0, -1, -1*delta_h, 1]]))




# Define the function under integral sign in objective function
def L_p(x, u, t, extra_data_persuer):
    assert len(x) == sys_dim_p
    assert len(u) == num_inputs_p
    return 1  # Time Optimal


# Derivative of L w.r.t x,u
def L_der_p(x, u, t, extra_data_persuer):
    assert len(x) == sys_dim_p
    assert len(u) == num_inputs_p
    return(np.array([0, 0, 0, 0]))


# Define the final time function to be minimized called phi
def phi_p(xf, tf, extra_data_persuer):
    return ([0])


# Derivative of phi w.r.t. t,x
def phi_der_p(xf, tf, extra_data_persuer):
    return(np.array([0, 0, 0, 0]))


extra_data_persuer = 0


# Timing the various points in x-y plane
wb = openpyxl.load_workbook('example.xlsx')
state_sheet = wb['States']
time_sheet = wb['Time']
data_sheet = wb['Data']

m = int(data_sheet['A1'].value)
n = int(data_sheet['B1'].value)

counter = 0
for i in range(0, m):
    for j in range(0, n):
        if str(time_sheet['A'+str(counter+1)].value) in ('None', 'Not Found'):
            # Defining End point Constraints
            xx = float(state_sheet['A'+str(counter+1)].value)
            yy = float(state_sheet['B'+str(counter+1)].value)
            def psi_p(xf, delta_t, extra_data_persuer):
                return np.array([xf[0]-xx, xf[1]-yy])


            # Define Derivatives of psi with respect to state at end point
            def psi_der_p(xf, delta_t, extra_data_persuer):
                return np.array([[1, 0, 0], [0, 1, 0]])
        
            count_optimal_try = 0  # To limit the number of atempts at trying
            fail = 0
            status = 1   # To run the algorithm till answer is not found
            while(status !=0):
                count_optimal_try += 1
                [lambdas, states, inputs, time, obj, status] = \
                    optimal.time_opt(sys_dyn_p, sys_der_p, sys_dim_p, num_inputs_p,
                         psi_p, psi_der_p, psi_dim_p, phi_p, phi_der_p,
                         L_p, L_der_p, x_initial_p, x_final_p,
                         state_limits_L_p, state_limits_U_p,
                         time_limit_L_p, time_limit_U_p,
                         N_p, extra_data_persuer)

                if count_optimal_try > 15:
                    status = 0
                    fail = 1
                    time_sheet['A'+str(counter+1)] = "Not Found"

            if fail == 0:
                time_sheet['A'+str(counter+1)] = obj

            wb.save('./example.xlsx')

        counter += 1
