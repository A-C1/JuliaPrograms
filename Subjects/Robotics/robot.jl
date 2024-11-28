using CairoMakie
using Statistics

fig = Figure()
ax = Axis(fig[1, 1])

x = (0.1:0.1:10) .+ 1e7
y = 1:100

scatter!(ax, x .- mean(x) , y)
save("example.png", fig)



