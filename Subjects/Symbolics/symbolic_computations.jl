using Symbolics

# Function to be optimized
function f(x)
    return exp(x[1]*x[2]*x[3]*x[4]*x[5]) - ((x[1]^3 + x[2]^3 + 1)^2) / 2
end

@variables x[1:5]
x = [x[1], x[2], x[3], x[4], x[5]]
f(x)
gradsym_f = Symbolics.gradient(f(x), x)
jacsym_f = Symbolics.jacobian(gradsym_f, x)
jacsym_f[1]

function g1(x)
    return x[1]^2 + x[2]^2 + x[3]^2 + x[4]^2 + x[5]^2 - 10
end

gradsym_g1 = Symbolics.gradient(g1(x), x)
hess_g1 = Symbolics.jacobian(gradsym_g1, x)

function g2(x)
    return x[2]*x[3] - 5*x[4]*x[5]
end

gradsym_g2 = Symbolics.gradient(g2(x), x)
hess_g2 = Symbolics.jacobian(gradsym_g2, x)

function g3(x)
    return x[1]^3 + x[2]^3 + 1
end

gradsym_g3 = Symbolics.gradient(g3(x), x)
#hess_g3 = Symbolics.jacobian(gradsym_g3, x)