using Plots

x0 = 0.0; y0 = 0.0; u0 =2.0; v0= 2.0
s0 = [x0, y0, u0, v0]

function sys_dyn(s, th, dt, a)
	sn = zeros(4)
	sn[1] = s[1] + dt*s[3]
	sn[2] = s[2] + dt*s[4]
	sn[3] = s[3] + dt*cos(th)
	sn[4] = s[4] + dt*sin(th)
	return sn
end

a = 1.0
v = sqrt(u0^2 + v0^2)
tm = 2v/a
th = 0:2π/25:(2π+2π/25)
tf = 2*tm
dt = 0.01
time = 0:dt:tf

fig1 = plot(label = false, aspect_ratio = 1, frame_style = :box)

sn = zeros(4, length(time))
sn[:, 1] .= s0

for theta in th
	for i=2:length(time)
		sn[:,i] = sys_dyn(sn[:,i-1], theta, dt, a)
	end
	plot!(fig1, sn[1,:], sn[2,:], label=false, aspect_ratio = 1)
end

th = 0:0.01:2π
xc = x0 + u0*tf
yc = y0 + v0*tf
R = 0.5*a*tf^2
xunit_p = R * cos.(th) .+ xc
yunit_p = R * sin.(th) .+ yc

# plot!(fig1, xunit_p, yunit_p, label = L"$\textrm{Reachable \; set}$", color = :black)
plot!(fig1, xunit_p, yunit_p, color = :black, lw = 2, label = nothing)
scatter!(fig1, [x0], [y0], label=nothing)
xlabel!(fig1, L"$x-\textrm{position}$")
ylabel!(fig1, L"$y-\textrm{position}$")

tf = tm
xc = x0 + u0*tf
yc = y0 + v0*tf
R = 0.5*a*tf^2
xunit_p = R * cos.(th) .+ xc
yunit_p = R * sin.(th) .+ yc

plot!(fig1, xunit_p, yunit_p, color = :grey, lw = 2, label = nothing)
# xc = x0 + u0*(tf/2)
# yc = y0 + v0*(tf/2)
# R = 0.5*a*(tf/2)^2
# xunit_p = R * cos.(th) .+ xc
# yunit_p = R * sin.(th) .+ yc

# plot!(fig1, xunit_p, yunit_p, label = false)
# display(fig1)