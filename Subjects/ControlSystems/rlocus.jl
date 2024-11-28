using ControlSystems
using Plots
plotlyjs()

sys = tf([3, 1], [9, 7, 5, 6])
sys1 = tf([0.1, 2, 3], [4, 0.5, 6])
sys2 = tf([0.5], [1, 1.5, 2])
sys3 = tf([-2], [1, -4, -4, -4])

k = 1:0.5:5
rlocusplot(sys2, k)

function rlocusplot1(sys::TransferFunction; K = 500)
    roots, Z, K = rlocus(sys; K)

    redata = real.(roots)
    imdata = imag.(roots)

    fig1 = plot(legend=nothing)
    for i = 1:size(roots)[2]
        plot!(fig1, redata[:, i], imdata[:, i])
    end

    Z = ComplexF64.(Z)
    for z in Z
        plot!(fig1, real(Z), imag(Z), markershape=:circle)
    end

    for (r, i) in zip(redata[begin, :], imdata[begin, :])
        plot!(fig1, [r], [i], markershape=:cross)
    end

    display(fig1)
end

