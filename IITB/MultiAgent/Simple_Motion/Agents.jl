using LinearAlgebra
using Plots

abstract type System end


struct KinematicPoint 
	currentState
	state
	input
end

function dynamics(sys::KinematicPoint, input)
	x = sys.currentState
	return [cos(input), sin(input)]
end

function step!(sys::KinematicPoint, input, dt, iter_no)
	sys.state[:,iter_no] = sys.currentState
	sys.input[iter_no] = input
	nextState = sys.currentState .+ dt*dynamics(sys, input)
	sys.currentState[:] = nextState
end

t0 = 0
T = 10
dt = 0.1
t = 0:0.1:10
N = length(t)

stateHistory = zeros(2, N)
inputHistory = zeros(N)
initialState = [0.0, 0.0]

a0 = KinematicPoint(initialState, stateHistory, inputHistory)

for i = 1:N
	step!(a0, π/4, dt, i )
end

plotlyjs()
plot(a0.state[1,:], a0.state[2, :], aspect_ratio =1)