struct SparseMatrixLTriplet1{T <: AbstractFloat, S <: Int}
    rowind::Vector{S}
    colind::Vector{S}
    valA::Vector{T}
end

SparseMatrixLTriplet = SparseMatrixLTriplet1

struct SparsMatrixLCSC0{T <: AbstractFloat}
    rowptrA::Vector{T}
    colindA::Vector{T}
    valA::Vector{T}
end

function SparseMatrixLCSC0(rowind::Vector{Int64}, colind::Vector{Int64}, val::Vector{Float64})
    # Sort the  rowind and colind in the row order
    pc = sortperm(colind)
end

SparseMatrixLCSR = SparseMatrixLCSR0

struct SMLGraphs
    N::Int64   # Number of vertices
    AL::Vector{Vector{Int64}}  # Adjacency list representation
end

SparseMatrixLCSR = SparseMatrixLCS0

rowindA = [3, 2, 3, 4, 1, 1, 2, 5, 3, 5]
colindA = [3, 2, 1, 4, 4, 1, 5, 5, 5, 2]
valA = [3.0, 1.0, -1.0, 1.0, -2.0, 3.0, 4.0, 6.0, 1.0, 7.0]

A = SparseMatrixtriplet(rowindA, colindA, valA)