using LinearAlgebra
using Plots

function f1(x,t)
    return sin(t)
end


global dt = 0.01
Tf = 6
x0 = 0.1

iter = Int(Tf/dt)

state = zeros(iter)
time = collect(0:dt:Tf)

state[1] = x0
for i=1:iter-1
    global h
    state[i+1] = state[i] + dt*f1(state[i], time[i])
end

plot(time[1:iter], state)

function newton_method(f, x)
end




	


