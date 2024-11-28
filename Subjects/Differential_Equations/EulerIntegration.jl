using LinearAlgebra
using GLMakie
using Infiltrator

function f(x, t, u)
    return [cos(x[3]), sin(x[3]), u]
end

function forwardeuler(f ; x0, h, tint)
    t0, tf = tint
    iter = Int((tf - t0)/ h)
	sys_dim = length(x0)

    state = zeros(sys_dim, iter)
    time = LinRange(t0, tf, iter)

    state[:,1] .= x0
    for i = 1:iter-1
		u = 1.0
        state[:,i+1] .= state[:, i] + h * f(state[:,i], time[i], u)
    end

    return lines(state[1,:], state[2,:])
end

function ode23(f;x0, tspan, reltol = 1e-3, abstol = 0.02, maxiter = 10000)
    t0, tf = tspan
    # sysdim = length(x0)
    state = Vector{Float64}[]   # Unnecessary memory allocated
    time = Float64[]

    h0 = 0.1
    xn = x0
    xns = x0
    tn = t0
    un = -1.0
    hn = h0
    update_state = true
    i = 1
    iter = 1
    preverr = true
    prevpreverr = true
    while (tn < tf) 
        if update_state == true
            push!(state, xn)
            push!(time, tn)
            i = i + 1
        end
         
        iter = iter + 1
        if iter > maxiter
            break
        end
        k1 = f(xn, tn, un)
        k2 = f(xn + hn*(0.5*k1), tn + 0.5*hn, un)
        k3 = f(xn + hn*(0.75*k2), tn + 0.75*hn, un)

        xn_t = xn + hn*(2*k1/9 + k2/3 + 4*k3/9)

        k4 = f(xn, tn + hn, un)

        xns_t = xn + hn*( 7*k1/24 + k2/4 + k3/3 + k4/8) 

        lerr = norm(xn_t - xns_t)

        # @infiltrate
        cond = lerr < hn*abstol
        if cond
            update_state = true
            xn = xn_t
            xns = xns_t
            tn = tn + hn
            if preverr && prevpreverr
                hn = 1.5*hn
            end
            prevpreverr = preverr
            preverr = cond
        else
            hn = hn*0.5
            update_state = false
            prevpreverr = preverr
            preverr = cond
        end


    end

    state1 = stack(state)
    return lines(state1[1,1:i-1], state1[2,1:i-1])
end

function rk4(f, h, Tf, x0)
end

h = 0.01
Tf = 6
x0 = [0.0, 0.0, 0.0]

# l = forwardeuler(f; h = h, tint = (0, Tf), x0 = x0)
l1 = ode23(f; x0 = x0, tspan = (0, Tf))

function type_unstable()
    if rand() > 0.5
        return "Aditya"
    else
        return 3.0
    end
end



	


