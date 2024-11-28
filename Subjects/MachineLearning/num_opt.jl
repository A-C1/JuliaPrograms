using NLOptControl

X0 = [0.0, 0.0, 0.0]
XF = [2., -2., NaN]

n = define(numStates=3, numControls=1, X0=X0, XF=XF)

# states!(n, [:x, :y, :v], descriptions=["x(t)", "y(t)", "v(t)"])
# controls!(n, [:u], descriptions=["u(t)"])

# dx=[:(v[j]*sin(u[j])),:(-v[j]*cos(u[j])),:(9.81*cos(u[j]))]
# dynamics!(n,dx)

# configure!(n;(:Nck=>[100]),(:finalTimeDV=>true))

# @NLobjective(n.ocp.mdl,Min,n.ocp.tf)
# optimize!(n)

# allPlots(n)