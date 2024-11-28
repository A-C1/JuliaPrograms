using CairoMakie
using LinearAlgebra
using Plots

import Ipopt

#INITIALISATIONS
# Constants
# (Maximum) speeds
function main()

vm_p = 2.0
vm_e = 1.0


# Max curvatures
um_p = 1.0      
um_e = 1.0

l = 0.05 ## Capture distance

x_p0 = 0.0
y_p0 = 0.0
th_p0 = 0.0

x_e0 = 0.0
y_e0 = 7.0
th_e0 = -pi/2

n = 200    # Time steps for PURSUER optimisation
tmin = (2*pi*0.6)/vm_p
tmax = 10.0

N = 200  # Time steps for EVADER optimisation

#INITIALIZATIONS CONTD
#Fix an initial trajectory xe_0(T) of the evader

#Initializing Pursuer

pursuer = Model(Ipopt.Optimizer)
set_silent(pursuer)

# Decision variables
@variables(pursuer, begin
    tmin/n <= Δt <= tmax/n     # Time step    # Heristics needed here to change tmin, tmax

    ## State variables
    x_p[1:n]            
    y_p[1:n]        
    th_p[1:n]           # Orientation 
    ## Control variables
    -um_p ≤ u_p[1:n] ≤ um_p

    ## Evader's terminal position
    x_eT == x_e0
    y_eT
    th_eT == th_e0

end)

@objective(pursuer, Min, Δt)

fix(x_p[1], x_p0; force = true)
fix(y_p[1], y_p0; force = true)
fix(th_p[1], th_p0; force = true)

@constraint(pursuer, y_eT == y_e0-1.0*n*Δt)        #Initial Random trajectory

@NLconstraint(pursuer, (x_p[n]-x_eT)^2 + (y_p[n]-y_eT)^2 <= l*l)

## Dynamics

for j in 2:n 

    @NLconstraint(pursuer, x_p[j] == x_p[j - 1] + Δt *0.5* vm_p*(cos(th_p[j - 1])+cos(th_p[j])))
    # Trapezoidal integration
    @NLconstraint(pursuer, y_p[j] == y_p[j - 1] + Δt *0.5* vm_p*(sin(th_p[j - 1])+sin(th_p[j])))
    # Trapezoidal integration
    @NLconstraint(pursuer, th_p[j] == th_p[j - 1] + 0.5*Δt *vm_p* (u_p[j]+u_p[j-1]))
    # Trapezoidal integration

end

## Solve PD to obtain e_0, T_0 and α_0
println("Solving...")
optimize!(pursuer)
solution_summary(pursuer)

#T_0
println("Time taken: ", n*objective_value(pursuer))
Plots.plot(value.(x_p),value.(y_p),fmt=:png,aspect_ratio = 1,legend = false)
#e_0
(value.(x_eT), value.(y_eT))
print(value.(u_p))
value.(x_p[n]), value.(y_p[n])


threshold = 0.0001   ## ------------------- NEED TO TUNE THIS
condition = true
iter = 1

X_e::Vector{Float64} = []
Y_e::Vector{Float64} = []
Th_e::Vector{Float64} = []
U_e::Vector{Float64} = []
t::Vector{Float64} = []

while condition # ------- Try to keep what all is possible out of the loop

    ## ------------------------------------- EVADER PART -------------------------------------
    #Solve ED using e_k, T_k and α_k
    evader = Model(Ipopt.Optimizer)
    set_silent(evader)

    # CONSTANTS here
    Δt = value.(Δt)
    #expression for α
    denom_first = dot([2*value.(x_p[n]-x_eT) 2*value.(y_p[n]-y_eT)], [vm_p*cos(value.(th_p[n])) vm_p*sin(value.(th_p[n]))])
    denom_second = dot(-[2*value.(x_p[n]-x_eT) 2*value.(y_p[n]-y_eT)], [vm_e*cos(value.(th_eT)) vm_e*sin(value.(th_eT))])

    α = -1/(denom_first+denom_second)

    #quantities required for objective function
    dlbyde = [2*value.(x_eT-x_p[n]) 2*value.(y_eT-y_p[n])]
    first_term = α*dlbyde

    # Decision variables
    @variables(evader, begin

        ## State variables
        x_e[1:N]            
        y_e[1:N]        
        th_e[1:N]           # Orientation 
        ## Control variables
        -um_e ≤ u_e[1:N] ≤ um_e
    end)

    fix(x_e[1], x_e0; force = true)
    fix(y_e[1], y_e0; force = true)
    fix(th_e[1], th_e0; force = true)

    ## Dynamics

    for j in 2:N

        @NLconstraint(evader, x_e[j] == x_e[j - 1] + Δt *0.5* vm_e*(cos(th_e[j - 1])+cos(th_e[j])))
        ## Trapezoidal integration
        @NLconstraint(evader, y_e[j] == y_e[j - 1] + Δt *0.5* vm_e*(sin(th_e[j - 1])+sin(th_e[j])))
        ## Trapezoidal integration
        @NLconstraint(evader, th_e[j] == th_e[j - 1] + 0.5*Δt *vm_e* (u_e[j]+u_e[j-1]))
        ## Trapezoidal integration

    end

    @objective(evader, Max, (x_e[N]-value.(x_eT))*first_term[1] + (y_e[N]-value.(y_eT))*first_term[2])

    println("Solving Evader...")
    optimize!(evader)

    #Δt_opt = Δt      # Δt found after previous pursuer optimisation

    x_eT_prev, y_eT_prev = x_eT, y_eT

    ## --------------------------------------PURSUER PART-------------------------------------------
    pursuer = Model(Ipopt.Optimizer)
    set_silent(pursuer)

    ## Evader's terminal position
    x_eT = value.(x_e[N])
    y_eT = value.(y_e[N])
    th_eT = value.(th_e[N])


    # Decision variables

    @variables(pursuer, begin
        tmin/n <= Δt <= tmax/n     # Time step                       # HEURISTICS NEEDED HERE

        ## State variables
        x_p[1:n]            
        y_p[1:n]        
        th_p[1:n]           # Orientation 
        ## Control variables
        -um_p ≤ u_p[1:n] ≤ um_p
        
    end)

    @objective(pursuer, Min, Δt)

    fix(x_p[1], x_p0; force = true)
    fix(y_p[1], y_p0; force = true)
    fix(th_p[1], th_p0; force = true)


    @NLconstraint(pursuer, (x_p[n]-x_eT)^2 + (y_p[n]-y_eT)^2 <= l*l)

    ## Dynamics

    for j in 2:n

        @NLconstraint(pursuer, x_p[j] == x_p[j - 1] + Δt *0.5* vm_p*(cos(th_p[j - 1])+cos(th_p[j])))
        ## Trapezoidal integration
        @NLconstraint(pursuer, y_p[j] == y_p[j - 1] + Δt *0.5* vm_p*(sin(th_p[j - 1])+sin(th_p[j])))
        ## Trapezoidal integration
        @NLconstraint(pursuer, th_p[j] == th_p[j - 1] + 0.5*Δt *vm_p* (u_p[j]+u_p[j-1]))
        ## Trapezoidal integration

    end

    #Solve PD using the extended solution to obtain e_(k+1), T_(k+1), α_(k+1)
    println("Solving Pursuer...")
    optimize!(pursuer)

    #Plotting both of them together
    x::Matrix{Float64} = [value.(x_e) value.(x_p)]; y = [value.(y_e) value.(y_p)]

    title = string("After iteration ",iter)
    fig = plot(x, y, title = title,fmt=:png, label = ["Evader" "Pursuer"], legend = false, aspect_ratio = 1)
    display(fig)
    
    iter = iter + 1
    condition = (value.(x_eT_prev-x_eT))^2+(value.(y_eT_prev-y_eT))^2 > threshold
    
    push!(t,value.(Δt)*n)
    
    if condition == false
        X_e,Y_e,Th_e,U_e = value.(x_e),value.(y_e),value.(th_e),value.(u_e)
    end
end

arrow_len = 0.2
xp_arrow, yp_arrow = zeros(200), 0:arrow_len/199:arrow_len
xe_arrow, ye_arrow = x_e0.+xp_arrow, y_e0.-yp_arrow

x = [X_e value.(x_p) xp_arrow xe_arrow]; y = [Y_e value.(y_p) yp_arrow ye_arrow]

fig = plot(x, y, fmt=:png, label = ["Evader" "Pursuer"], legend = false, aspect_ratio = 1, framestyle = :box, arrow = true)
# display(fig)
# Plots.savefig(fig,"yash_0comma7commaMinus90pursuer90.pdf")
# using CSV, DataFrames
# matrix = hcat(value.(x_p),value.(y_p),value.(th_p),value.(u_p),X_e,Y_e,Th_e,U_e)
# CSV.write("home/twoCarsData.csv", DataFrame(matrix, :auto),header = false, append = true)
end

# Run the function main
main()
