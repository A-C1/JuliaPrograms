using BenchmarkTools
using Base.Threads
acc = Atomic{Int64}(0)
@threads for i in 1:10_000
    global acc
    atomic_add!(acc, 1) 
end
acc

# Writing code is fun
# Maybe I should get back to my JuMP code