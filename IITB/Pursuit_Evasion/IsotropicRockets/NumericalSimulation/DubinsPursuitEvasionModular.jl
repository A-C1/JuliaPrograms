using JuMP
using LinearAlgebra
using Plots
# using CSV, DataFrames
import Ipopt
using LaTeXStrings
using Interpolations

# File which contains function to solve pursuer's problem
include("pursuer_problem.jl")
# File which contains function to solve evader's problem
include("evader_problem.jl")

# Function to simulate initial Dubins trajectory
function dubins_next_state(s, th, δt, a_e)
    sn = zeros(4)
    sn[1] = s[1] + s[3] * δt
    sn[2] = s[2] + s[4] * δt
    sn[3] = s[3] + a_e * cos(th) * δt
    sn[4] = s[4] + a_e * sin(th) * δt
    return sn
end

function plot_reachable(s0, a, fig, tf, color, label)
    x0 = s0[1]
    y0 = s0[2]
    u0 = s0[3]
    v0 = s0[4]
    v = sqrt(u0^2 + v0^2)
    tm = 2v / a
    th = 0:0.01:2π
    xc = x0 + u0 * tf
    yc = y0 + v0 * tf
    R = 0.5 * a * tf^2
    xunit_p = R * cos.(th) .+ xc
    yunit_p = R * sin.(th) .+ yc

    plot!(fig, xunit_p, yunit_p, color = color, label = label)
end


struct Params
	# Pursuer parameters
    am_p::Float64
    state_p0::Vector{Float64}
    n::Int64

	# Evader parameters
    am_e::Float64
    state_e0::Vector{Float64}
    N::Int64

    l::Float64   # Capture distance
end

am_p = 2.0
state_p0 = [0.0, 0.0, 0.25, -0.25]
n = 80

am_e = 1.0
state_e0 = [5.0, 0.0, 0.5, 0.5]
N = n
l = 0.05
params = Params(am_p, state_p0, n,
                am_e, state_e0, N, l)


function main(params)
    (; am_p, state_p0, n, am_e, N, state_e0, l) = params
    x_e0, y_e0, u_e0, v_e0 = state_e0[1], state_e0[2], state_e0[3], state_e0[4]
    x_p0, y_p0, u_p0, v_p0 = state_p0[1], state_p0[2], state_p0[3], state_p0[4]


    #-------------------------------------------------------
    # Initial randomly generated evader trajectory
    δt = 0.07
    timeE = LinRange(0.0, δt * N, N)

    se = zeros(4, length(timeE))
    se[:, 1] = [x_e0, y_e0, u_e0, v_e0]
    for i = 1:(length(timeE)-1)
        se[:, i+1] = dubins_next_state(se[:, i], π/4, δt, am_e)
    end
    x_e = se[1, :]
    y_e = se[2, :]

    # -----------------------------Initial pursuer solution-------------------------------------------
    x_p, y_p, u_p, v_p, th_p, Δt, α = pursuer_optimal(x_e, y_e, δt, params)


    # Solve iteratively
    iter = 1
	NI = n
	Δt = 1.0
    while iter < 2
        #-----------------------------------------------------------------------------------------
        #------------------------------------- EVADER PART -------------------------------------
        x_e, y_e, u_e, v_e, th_e = evader_optimal(x_p, y_p, 0.0, 0.0, th_p, δt, params, α)
        #-----------------------------------------------------------------------------------------
        #--------------------------------------PURSUER PART-------------------------------------------
        x_p, y_p, u_p, v_p, th_p, Δt, α = pursuer_optimal(x_e, y_e, δt, params)
		NI = Int(floor(Δt*N/δt))
        

        iter = iter + 1
        # fig1 = plot(x_e, y_e, aspect_ratio = 1)
        # plot!(x_p, y_p)
        # display(fig1)
    end

	# Nice plot code------------------------------------------
    fig1 = plot(aspect_ratio=1, frame_style=:box, lw=2, legend=:topleft)
	plot!(fig1, x_e[1:NI], y_e[1:NI], color=:red, ls=:dash, lw=2, label=L"$\textrm{Evader \; trajectory}$")
    plot!(fig1, x_p, y_p, color=:blue, ls=:dashdot, lw=2, label=L"$\textrm{Pursuer \; trajectory}$")
	scatter!(fig1, [x_e0], [y_e0], label=nothing)
    scatter!(fig1, [x_p0], [y_p0], label=nothing)
    scatter!(fig1, [x_p[end]], [y_p[end]], markershape = :star, label=nothing)
	xlabel!(fig1, L"$x-\textrm{position}$")
	ylabel!(fig1, L"$y-\textrm{position}$")
	annotate!(fig1, x_p0 - 0.5, y_p0 - 0.9, L"$\bf{P}$")
	annotate!(fig1, x_e0 - 0.5, y_e0 - 0.9, L"$\bf{E}$")
	# Reachable set
	plot_reachable(state_p0, am_p, fig1, Δt*(N-1), :green, L"$\textrm{Pursuer's \; reachable \; set}$" )
	plot_reachable(state_e0, am_e, fig1, Δt*(N-3), :brown, L"$\textrm{Evader's \; reachable \; set}$" )
    display(fig1)
	# Nice plot code ends--------------------------------------
end

# Run the function main
main(params)