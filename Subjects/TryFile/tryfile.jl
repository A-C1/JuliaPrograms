mutable struct Try6{T <: Number}
    a::Vector{T}
    function Try6(a::Vector{T}) where {T <: Number}
        x = new{T}()
        x.a = a
         
        return x
    end
end

function Try6()
    return Try6(Int64[])
end