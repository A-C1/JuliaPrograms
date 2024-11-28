using Ipopt

function time_opt(sys_dyn, sys_der, sys_dim, num_inputs, 
                  psi, psi_der, dim_psi, phi, phi_der, 
                  L, L_der, x_initial, x_final, 
                  state_limits_L, state_limits_U,
                  time_limit_L, time_limit_U,
                  N, extra_data)

    # Alias created for ease of handeling
    e_d = extra_data
    new_dim = sys_dim + num_inputs

    # Total number of variables over which optimization has to be done
    nvar = 1 + (new_dim)*N


    x_L = zeros(nvar)  # Lower limits of Varaibles
    x_U = zeros(nvar)  # Upper Limits of Variables

    for i=1:N
        for j=1:new_dim
            x_L[(i-1)*new_dim + j + 1] = state_limits_L[j]   # Assigning lower limits
            x_U[(i-1)*new_dim + j + 1] = state_limits_U[j]   # Assigning upper limits
        end
    end
            

    # Time is always positive
    x_L[1] = time_limit_L  # T_lower is set to a very small positive value
    x_U[1] = time_limit_U  # T_upper is set equal to 50

    # This sets the inital value of the problem
    # Currently it is fixed
    # Edit to make it like final time
    for i=1:sys_dim
        x_L[i+1] = x_initial[i]
        x_U[i+1] = x_initial[i]

    # This Sets the final time state
    # If there is no fixed final value then
    # the corresponding value is set as relative
    # and the final states are alowed to vary
    # between upper and lower limits
    for i in range(-new_dim, -num_inputs):
        if x_final[(i+new_dim)] == "rel":
            x_L[i] = state_limits_L[(i+new_dim)]
            x_U[i] = state_limits_U[(i+new_dim)]
        else:
            x_L[i] = x_final[(i+new_dim)]
            x_U[i] = x_final[(i+new_dim)]

    # Number of constraints
    ncon = sys_dim*(N-1) + dim_psi

    # Equality Constraints Limits
    g_L = np.zeros(ncon)
    g_U = np.zeros(ncon)

    # Inequality Constraints on psi
    # Note: By this assignment the psi constraints are at the very end
    if dim_psi != 0:
        g_L[-dim_psi:] = [-0.1]
        g_U[-dim_psi:] = [0.1]

    # Define the function to be optimized
    def eval_f(x, user_datac=None):
        J_val = 0
        x_f = x[-new_dim:-new_dim + sys_dim]
        for i in range(0, N):
            # Extract x and u at each instant
            x_i = x[1+i*new_dim:1+i*new_dim+sys_dim]
            u_i = x[1+i*new_dim+sys_dim:1+i*new_dim+new_dim]
            t_i = i*x[0]
            J_val = J_val + L(x_i, u_i, t_i, e_d)*x[0]

        J_val = J_val + phi(x_f, t_i, e_d)

        return J_val

    # Gradient of function to be optimized
    def eval_grad_f(x, user_datac=None):
        assert len(x) == nvar
        xf = x[-new_dim:-new_dim + sys_dim]
        tf = N*x[0]
        z = np.zeros(len(x))  # z stores the value of gradient
        #  z[0] is derivative of z w.r.t time
        z[0] = (eval_f(x) - phi(xf, tf, e_d))/x[0] + phi_der(xf, tf, e_d)[0]

        for i in range(0, N):
            x_i = x[1+i*new_dim:1+i*new_dim+sys_dim]
            u_i = x[1+i*new_dim+sys_dim:1+i*new_dim+new_dim]
            t_i = i*x[0]
            z[1+i*new_dim:1+(i+1)*new_dim] = L_der(x_i, u_i, t_i, e_d)*x[0]

        z[1+(N-1)*new_dim:1+((N-1)+1)*new_dim-num_inputs] += \
            phi_der(xf, tf, e_d)[1:]
        return z

    # This function adds the constaints
    # First are the costraints which connectes states through time
    # by dynamic equations. Later are the final time constraints
    def eval_g(x, user_data=None):
        assert len(x) == nvar
        const = np.zeros([ncon])
        for i in range(0, N-1):
            const[sys_dim*i:sys_dim*i+sys_dim] = x[1+new_dim*(i+1):1+new_dim *
                                                   (i+1)+sys_dim] -       \
                    sys_dyn(x[1+new_dim*i:1+new_dim*i+new_dim], x[0])

        if dim_psi != 0:
            const[-dim_psi:] = psi(x[-(sys_dim+num_inputs):-num_inputs], x[0],
                                   e_d)

        return const

    # Total number of non-zero elements in Jacobian
    nnzj = (N-1)*sys_dim*(sys_dim+num_inputs+2) + dim_psi*sys_dim
    # print(nnzj)

    def eval_jac_g(x, flag, user_data=None):
        # the if block stores the entry indices of the Jacobian which are nonzero
        # the else block stores the values
        # In the Jacobian each column corresponds to a particular variable

        if flag:
            array1 = []  # Stores the row index of Jacobian entry
            array2 = []  # Stores the column index of Jacobian Index
            # First for loop block is for enforcing system dynamics

            # i and j are for iterating through constraints
            # while k is for iterating through vars w.r.t. which
            # derivatives have to be taken
            for i in range(0, N-1):
                for j in range(0, sys_dim):
                    for k in range(0, 2+sys_dim+num_inputs):  # the 2 comes because of shift due to time and x(k+1)
                        if k == 0:
                            array1.append(sys_dim*i+j)
                            array2.append(0)
                        elif 1 <= k <= (sys_dim + num_inputs):
                            array1.append(sys_dim*i+j)
                            array2.append((sys_dim+num_inputs)*i+k)
                            # K prevents zero indexing so no 1
                        else:
                            array1.append(sys_dim*i+j)
                            array2.append(1 +
                                          (i+1)*(sys_dim+num_inputs) + j)

            # Second for loop block is for enforcing the end point constraints
            for j in range(0, dim_psi):
                for k in range(0, sys_dim):
                    array1.append(sys_dim*(N-1)+j)
                    array2.append(1+(sys_dim+num_inputs)*(N-1)+k)
                    # print(array1, array2)
                    # print(len(array1), len(array2))
            return (np.array([array1]), np.array([array2]))
        else:
            g1 = []
            assert len(x) == nvar
            for i in range(0, N-1):
                for j in range(0, sys_dim):
                    for k in range(0, 2+sys_dim+num_inputs):
                        g1.append(sys_der(x[1+new_dim*i:1+new_dim*i+new_dim],
                                          x[0])[j][k])

            for j in range(0, dim_psi):
                for k in range(0, sys_dim):
                    g1.append(psi_der(x[-(sys_dim+num_inputs):
                                        -num_inputs], x[0],
                                      e_d)[j][k])
                    # print(g1)
            return np.array([g1])

    nnzh = 0

    def apply_new(x):
        return True

    nlp = pyipopt.create(nvar, x_L, x_U, ncon, g_L, g_U, nnzj, nnzh,
                         eval_f, eval_grad_f, eval_g, eval_jac_g)

    # Provide initial estimate of the data
    x0 = traj_previous
    # x0 = 1.5*np.ones([nvar])
    # x0[1:sys_dim+1] = x_initial
    # x0[0] = 0.1

    # for i in range(1, N):
    #     x_old = x0[(i-1)*new_dim+1:(i-1)*new_dim+1+new_dim]
    #     x0[i*new_dim+1:i*new_dim+1+sys_dim] = sys_dyn(x_old, x0[0])



    # Setting Options of NLP Solver and setting its options
    nlp.num_option('tol', 1e-2)
    # nlp.int_option('print_level', 0)
    nlp.int_option('max_iter', 300)
    # nlp.str_option('hessian_approximation', 'limited-memory')

    # Calling  Ipopt to solve the problem
    x, zl, zu, constraint_multipliers, obj, status = nlp.solve(x0)
    nlp.close()

    # Returning Data in Suiable format
    t = np.zeros([N])
    y = np.zeros([sys_dim, N])
    u = np.zeros([num_inputs, N])
    for i in range(0, N):
        if i < N-1:
            t[i+1] = t[i] + x[0]
        for j in range(0, num_inputs):
            u[j][i] = x[1 + sys_dim + j + i*new_dim]
        for j in range(0, sys_dim):
            y[j][i] = x[(1+j+i*new_dim)]

    return constraint_multipliers, y, u, t, obj, status, x
        


end
