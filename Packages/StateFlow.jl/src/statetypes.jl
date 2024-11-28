abstract type AbstractState end
abstract type AbstractChart end

export State, Chart, MainChartData1

mutable struct State4{T <: AbstractState, S <: AbstractChart} <: AbstractState
    statename::String
    subcharts::Vector{S}
    stateout::Vector{T}
    statein::Vector{T}
    isrootstate::Bool
    transitionfunction
    activefunction

    function State4(name::String, subcharts::Vector{S}, stateout::Vector{T}, statein::Vector{T}) where {S <: AbstractChart, T <: AbstractState}
        newstate = new{T, S}()
        newstate.statename = name
        newstate.subcharts = subcharts
        newstate.stateout = stateout
        newstate.statein = statein
        newstate.isrootstate = false

        return newstate
    end
end

State = State4

struct Chart <: AbstractChart
    chartname::String
    states::Vector{AbstractArray}
end

Chart = Chart

State4(name::String) = State4(name, Chart[], State[], State[])

mutable struct MainChartData3{T<:AbstractState}
    activestate::T
    numstates::Int64
    dt::Float64
    ts::Float64
    tf::Float64
    tsecs::Float64
    output::Vector{Float64}
    input::Vector{Float64}
    locals::Vector{Float64}
end

MainChartData1 = MainChartData3

struct Output
    name::String
    value::Float64
end
