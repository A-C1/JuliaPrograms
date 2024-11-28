function evader_optimal(x_p, y_p, x_eT, y_eT, th_p, Δt, params, α)
	(;n, am_e, N, state_e0) = params
    x_e0, y_e0, u_e0, v_e0 = state_e0[1], state_e0[2], state_e0[3], state_e0[4]
    x_eC, y_eC = x_p[n], y_p[n]    							# This is hacky. Need to get this right.


    evader = Model(Ipopt.Optimizer)
    set_silent(evader)

    #quantities required for objective function
    dlbyde = [2*(x_eC-x_p[n-1]) 2*(y_eC-y_p[n-1])]
    first_term = -α*dlbyde

    # Decision variables
    @variables(evader, begin
        ## State variables
        x_e[1:N]            
        y_e[1:N]        
        u_e[1:N]            
        v_e[1:N]        

		# Control variable
        0 ≤	th_e[1:N] ≤ 2π          # Orientation 
    end)

    fix(x_e[1], x_e0; force = true)
    fix(y_e[1], y_e0; force = true)
    fix(u_e[1], u_e0; force = true)
    fix(v_e[1], v_e0; force = true)

    ## Dynamics

    for j in 2:N
        @NLconstraint(evader, x_e[j] == x_e[j - 1] + 0.5*Δt *(u_e[j]+u_e[j-1]))
        ## Trapezoidal integration
        @NLconstraint(evader, y_e[j] == y_e[j - 1] + 0.5*Δt * (v_e[j]+v_e[j-1]))
        ## Trapezoidal integration
        @NLconstraint(evader, u_e[j] == u_e[j - 1] + 0.5* Δt * am_e*(cos(th_e[j]) + cos(th_e[j-1])))
        ## Trapezoidal integration
        @NLconstraint(evader, v_e[j] == v_e[j - 1] + 0.5*Δt * am_e*(sin(th_e[j]) + sin(th_e[j-1])))
        ## Trapezoidal integration
    end

    @objective(evader, Max, (x_e[N]- x_eC)*first_term[1] + (y_e[N]-y_eC)*first_term[2])

    println("Solving Evader...")
    optimize!(evader)

    return value.(x_e), value.(y_e), value.(u_e), value.(v_e), value.(th_e)
end