using DSP
using Plots

function conv_naive(u, v)
    lu = length(u)  
    lv = length(v)  
    lc = lu + lv
    vn = [v; zeros(lu)]  # pad zeros to make size of signals equal
    un = [u; zeros(lv)]  # pad zeros to make size of signals equal
    vr =  reverse(vn)
    c = zeros(lc)
    for i = 1:lc
         c[i] = vr[end-i+1:end]'*un[1:i] 
    end
    return c
end

t1 = -10:0.01:0
g1 = -2exp.(2t1)
t2 = 0:.01:10
g2 = 2exp.(-t2)
t = [t1;t2]
g = [g1;g2]
f = [zeros(size(g1)); ones(size(g2))]
t = -20:0.01:5
c =  0.01*conv(f,g)
c1 = 0.01*conv_naive(f,g)
fig = plot(t[1700:end], c[1700:length(t)], aspect_ratio = :equal)
plot!(fig, t[1700:end], c1[1700:length(t)], aspect_ratio = :equal)
