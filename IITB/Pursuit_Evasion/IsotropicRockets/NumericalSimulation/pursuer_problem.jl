# Function to solve pursuers problem
function pursuer_optimal(x_e, y_e, δt, params)
	(;am_p, state_p0, n, N, l) = params

    x_p0, y_p0, u_p0, v_p0 = state_p0[1], state_p0[2], state_p0[3], state_p0[4]

    pursuer = Model(Ipopt.Optimizer)
    # set_silent(pursuer)

	timeE = LinRange(0,N*δt, N)

	function xval(Δt)
		#global δt, timeE, x_e, n
		interp = LinearInterpolation(timeE, x_e, extrapolation_bc = x_e[N])
		return interp(n*Δt)
	end
	register(pursuer,:xval, 1, xval; autodiff = true)
	
	function yval(Δt)
		#global δt, timeE, y_e, n
		interp = LinearInterpolation(timeE, y_e, extrapolation_bc = y_e[N])
		return interp(n*Δt)
	end
	register(pursuer,:yval, 1, yval; autodiff = true)

    # Decision variables
    @variables(pursuer, begin
        0.005 <= Δt <= 0.1     # Time step                       # HEURISTICS NEEDED HERE

        ## State variables
        x_p[1:n]
        y_p[1:n]
        u_p[1:n]           # x-speed
        v_p[1:n]           # y-speed
        ## Control variables
        0 ≤ th_p[1:n] ≤ 2π

    end)

    @objective(pursuer, Min, Δt)

    fix(x_p[1], x_p0; force=true)
    fix(y_p[1], y_p0; force=true)
    fix(u_p[1], u_p0; force=true)
    fix(v_p[1], v_p0; force=true)


	# Final conditions
	@NLconstraint(pursuer, con,(x_p[n] - xval(Δt))^2 + (y_p[n] - yval(Δt))^2 <= 0.1)
	# @NLconstraint(pursuer, con,(x_p[n] - 5.0)^2 + (y_p[n] - 5.0)^2 <= 0.1)

    for j in 2:n
        @NLconstraint(pursuer, x_p[j] == x_p[j-1] + 0.5 * Δt *  (u_p[j] + u_p[j-1]))
        ## Trapezoidal integration
        @NLconstraint(pursuer, y_p[j] == y_p[j-1] + 0.5 * Δt *  (v_p[j] + v_p[j-1]))
        ## Trapezoidal integration
        @NLconstraint(pursuer, u_p[j] == u_p[j-1] + 0.5 * Δt *  am_p * (cos(th_p[j]) + cos(th_p[j-1])))
        ## Trapezoidal integration
        @NLconstraint(pursuer, v_p[j] == v_p[j-1] + 0.5* Δt * am_p * (sin(th_p[j-1]) + sin(th_p[j-1])))
        ## Trapezoidal integration
    end

    #Solve PD using the extended solution to obtain e_(k+1), T_(k+1), α_(k+1)
    println("Solving Pursuer...")
    optimize!(pursuer)
    return value.(x_p), value.(y_p), value.(u_p), value.(v_p), value.(th_p), value.(Δt), dual(con)
end