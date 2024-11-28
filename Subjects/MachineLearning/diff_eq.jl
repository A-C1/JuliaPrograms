using DifferentialEquations, Plots

function cont_inp(state, target)
    yDif = target[2]-state[2]
    xDif = target[1]-state[1]
    angle = state[3]
    los_angle = atan(yDif, xDif)
    if los_angle < 0
        los_angle += 2*pi
    end

    if angle < los_angle 
        return 1.0
    else 
        return -1.0
    end
end

target = [10 10]

function lorenz!(du, u, p, t)
    global target
    du[1] = cos(u[3])
    du[2] = sin(u[3])
    du[3] = cont_inp(u, target)
end
u0 = [1.0 0.0 0.0]'
tspan = (0.0,10.0)
prob = ODEProblem(lorenz!,u0,tspan)
sol = solve(prob)

plot(sol, vars=(1,2), aspectratio =1)





