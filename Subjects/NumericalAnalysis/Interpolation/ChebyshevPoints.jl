using GLMakie

function computencheb(n)
    x = Vector{Float64}(undef, n)
    for i=1:n
        x[i] = cos((2*i+1)*π/(2*(n+1)))
    end
    return x
end

n = 10
x = computencheb(n)
y = zeros(length(x))
scatter(x, y)
