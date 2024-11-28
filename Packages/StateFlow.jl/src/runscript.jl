using StateFlow
using GLMakie


sON = State("ON")
sOFF = State("OFF")
sINBTWN = State("INBTWN")

mc = MainChartData1(sON, 2, 0.01, 0.0, 10.0, 0.0, [1.0], [0.0], [0.0])

function transitionfunctionON(m::MainChartData1)
    m.output[1] = 1.0
    if m.tsecs > 0.5
        m.activestate = sINBTWN
        m.tsecs = 0.0
        m.locals[1] = 2.0
    end
end

sON.transitionfunction = transitionfunctionON

function transitionfunctionOFF(m::MainChartData1)
    m.output[1] = 0.0
    if m.tsecs > 0.5
        m.activestate = sINBTWN
        m.tsecs = 0.0
        m.locals[1] = 0.0
    end
end

sOFF.transitionfunction = transitionfunctionOFF

function transitionfunctionINBTWN(m::MainChartData1)
    m.output[1] = 0.5
    if m.tsecs > 0.5
        if m.locals[1] === 0.0
            m.activestate = sON
            m.tsecs = 0.0
        else
            m.activestate = sOFF
            m.tsecs = 0.0
        end
        m.locals[1] = 1.0
    end
end

sINBTWN.transitionfunction = transitionfunctionINBTWN

timeiter = mc.ts:mc.dt:mc.tf
outputs = Float64[]
for i in timeiter
    mc.activestate.transitionfunction(mc)
    push!(outputs, mc.output[1])
    mc.tsecs = mc.tsecs + mc.dt
end

# lines(timeiter, outputs)
