using Plots
using JuMP
import Ipopt


# Function to solve pursuers problem
	am_p = 2.0
	state_p0 = [0.0, 0.0, 0.25, 0.0]
	n = 200
    l = 0.1

	# tmin and tmax are 
    tmin = (2 * pi * 0.6) / am_p
    tmax = 10.0
    x_p0, y_p0, u_p0, v_p0 = state_p0[1], state_p0[2], state_p0[3], state_p0[4]

    pursuer = Model(Ipopt.Optimizer)
    set_silent(pursuer)

	# timeE = LinRange(0,N*δt, N)

	# function xval(Δt)
	# 	#global δt, timeE, x_e, n
	# 	interp = LinearInterpolation(timeE, x_e, extrapolation_bc = x_e[N])
	# 	return interp(n*Δt)
	# end
	# register(pursuer,:xval, 1, xval; autodiff = true)
	
	# function yval(Δt)
	# 	#global δt, timeE, y_e, n
	# 	interp = LinearInterpolation(timeE, y_e, extrapolation_bc = y_e[N])
	# 	return interp(n*Δt)
	# end
	# register(pursuer,:yval, 1, yval; autodiff = true)

    # Decision variables
    @variables(pursuer, begin
        tmin / n <= Δt <= 0.01     # Time step                       # HEURISTICS NEEDED HERE

        ## State variables
        x_p[1:n]
        y_p[1:n]
        u_p[1:n]           # x-speed
        v_p[1:n]           # y-speed
        ## Control variables
        -π ≤ th_p[1:n] ≤ π

    end)

    @objective(pursuer, Min, Δt)

    fix(x_p[1], x_p0; force=true)
    fix(y_p[1], y_p0; force=true)
    fix(u_p[1], u_p0; force=true)
    fix(v_p[1], v_p0; force=true)


	# Final conditions
	@NLconstraint(pursuer, con,(x_p[n] - 5.0)^2 + (y_p[n] - 5.0)^2 <= l * l)

    for j in 2:n
        @NLconstraint(pursuer, x_p[j] == x_p[j-1] + 0.5 * Δt *  (u_p[j] + u_p[j-1]))
        ## Trapezoidal integration
        @NLconstraint(pursuer, y_p[j] == y_p[j-1] + 0.5 * Δt *  (v_p[j] + v_p[j-1]))
        ## Trapezoidal integration
        @NLconstraint(pursuer, u_p[j] == u_p[j-1] + Δt *  am_p * (cos(th_p[j])))
        ## Trapezoidal integration
        @NLconstraint(pursuer, v_p[j] == v_p[j-1] + Δt * am_p * (sin(th_p[j])))
        ## Trapezoidal integration
    end

    #Solve PD using the extended solution to obtain e_(k+1), T_(k+1), α_(k+1)
    println("Solving Pursuer...")
    optimize!(pursuer)
    # value.(x_p), value.(y_p), value.(u_p), value.(v_p), value.(v_p), value.(Δt), dual(con)
	# plot(value.(x_p), value.(y_p))
	plot(value.(th_p))