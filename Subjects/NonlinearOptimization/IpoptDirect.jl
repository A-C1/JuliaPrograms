using Ipopt

# Function to be optimized
function eval_f(x::Vector{Float64})
    return x[1] * x[4] * (x[1] + x[2] + x[3]) + x[3]
end

function eval_g(x::Vector{Float64})
    g[1] = x[1] * x[2] * x[3] * x[4]
    return g[2] = x[1]^2 + x[2]^2 + x[3]^2 + x[4]^2
end

function eval_grad_f(x::Vector{Float64}, grad_f::Vector{Float64})
    grad_f[1] = x[1] * x[4] + x[4] * (x[1] + x[2] + x[3])
    grad_f[2] = x[1] * x[4]
    grad_f[3] = x[1] * x[4] + 1

    return grad_f[4] = x[1] * (x[1] + x[2] + x[3])
end

function eval_jac_g(
    x::Vector{Float64}
    rows::Vector{Int32}
    cols::Vector{Int32}
    values::Union{Nothing,Vector{Float64}}
)


    if values === nothing
        # Constraint (row) 1
        rows[1] = 1
        cols[1] = 1
        rows[2] = 1
        cols[2] = 2
        rows[3] = 1
        cols[3] = 3
        rows[4] = 1
        cols[4] = 4
        # Constraint (row) 2
        rows[5] = 2
        cols[5] = 1
        rows[6] = 2
        cols[6] = 2
        rows[7] = 2
        cols[7] = 3
        rows[8] = 2
        cols[8] = 4
    else
        # Constraint (row) 1
        values[1] = x[2] * x[3] * x[4]  # 1,1
        values[2] = x[1] * x[3] * x[4]  # 1,2
        values[3] = x[1] * x[2] * x[4]  # 1,3
        values[4] = x[1] * x[2] * x[3]  # 1,4
        # Constraint (row) 2
        values[5] = 2 * x[1]  # 2,1
        values[6] = 2 * x[2]  # 2,2
        values[7] = 2 * x[3]  # 2,3
        values[8] = 2 * x[4]  # 2,4
    end
    return

end

