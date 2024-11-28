using .optimal


#Problem Data
N = 50       # No of steps

sys_dim = 3     # Dimension of the System
num_inputs = 1  # Number of inputs
psi_dim = 2     # Number of end point equality constraints

mul = -1  # Just for convinience of setting initial condition
x_initial = [0, 0., -(2*pi - pi*mul)]  # Initial Conditions
x_final = ["rel", "rel", "rel"]  # Final State,"rel" if free

# First Write the limits of states and then that of inputs
# [x' u']
state_limits_L = [-30, -30, -12.3, -1.5]  # Lower State limits
state_limits_U = [30, 30, 0, 0]
time_limit_L = 0/N
time_limit_U = 30/N
new_dim = sys_dim + num_inputs


# Dynamics of System
function sys_dyn(x, delta_h)
    v = 1  # Velocity of Dubins vehicle
    return [x[1] + v*cos(x[3])*delta_h, x[2] + v*sin(x[3])*delta_h, x[3] + v*x[4]*delta_h]
end


# Derivative of system dynamics
# with respect to states and inputs
# [h,x(k),u(k),x_i(k+1)]
function sys_der_p(xk, delta_h)
    v = 1  # Velocity of Dubins vehicle
    return [-v*np.cos(xk[3]) -1  0  delta_h*v*np.sin(xk[3])          0 1
            -v*np.sin(xk[3])  0 -1 -v*np.cos(xk[3])*delta_h          0 1
                      -xk[4]  0  0                       -1 -v*delta_h 1]
end


# Defining End point Constraints
function psi_p(xf, delta_t, extra_data_persuer)
    return [xf[0]-(0), xf[1]-(7)]
end


# Define Derivatives of psi with respect to state at end point
function psi_der_p(xf, delta_t, extra_data_persuer)
    return [1.0 0.0 0.0;
            0.0 1.0 0.0]
end


# Define the function under integral sign in objective function
function L_p(x, u, t, extra_data_persuer)
    return 1  # Time Optimal
end


# Derivative of L w.r.t x,u
function L_der_p(x, u, t, extra_data_persuer)
    return [0, 0, 0, 0]
end


# Define the final time function to be minimized called phi
function phi_p(xf, tf, extra_data_persuer)
    return [0]
end


# Derivative of phi w.r.t. t,x
function phi_der_p(xf, tf, extra_data_persuer)
    return [0, 0, 0, 0]
end


extra_data_persuer = 0


# Persuers Problem Ends here
status = 1
[lambdas, states, inputs, time, obj, status] = optimal.time_opt(sys_dyn_p, sys_der_p, sys_dim_p, num_inputs_p,
                                                                psi_p, psi_der_p, psi_dim_p, phi_p, phi_der_p,
                                                                L_p, L_der_p, x_initial_p, x_final_p,
                                                                state_limits_L_p, state_limits_U_p,
                                                                time_limit_L_p, time_limit_U_p,
                                                                N_p, extra_data_persuer)

println("Objective value")
# println("f(x*) = {}".format(obj))


fig1 = plot(states[0], states[1], aspect_ratio = 1)
xlabel!('x-position')
ylabel!('y-position')
