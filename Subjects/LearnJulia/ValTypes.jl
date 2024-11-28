struct PointND{N, T<:Real}
    data::NTuple{N, Int}
end


function create_points(::Val{n}) where {n}
    v = PointND{3, Float64}[]
    for i=1:n
       push!(v, PointND{3, Float64}((0,0,0))) 
    end
    return v
end

function create_point(::Val{N}) where N
    return PointND{N, Float64}(ntuple(i -> 2*i, Val(N)))
end

function create_point1(N)
    return PointND{N, Float64}(ntuple(i -> 2*i, N))
end