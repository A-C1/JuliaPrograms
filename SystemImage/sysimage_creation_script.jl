import Pkg

Pkg.add("PackageCompiler")
using PackageCompiler

Pkg.activate()

utilities = ["Cthulhu", "Infiltrator", "FloatingTableView", "BenchmarkTools", "JET", "IJulia", ]
plotting = ["GLMakie", "CairoMakie"] 
data_manip = ["DataFrames", "CSV"]
databases = ["LibPQ", "Arrow", "OnlineStatistics"]
optimization = ["JuMP", "Ipopt", "ForwardDiff"]
control_systems = ["ControlSystems", "DSP", "FFTW"]
machine_learning = ["Flux", "Lux", "SimpleChains", "MLJ", "MLUtils", "Optimisers", "Zygote", "DiffEqFlux"]
simulation = ["DifferentialEquations", "ModelingToolkit", "ModelingToolkitStandardLibrary","OrdinaryDiffEq", ]
numericalanalysis = ["Interpolations", "QuadGK", "BSplineKit", "DataInterpolations", "FiniteDiff", "FiniteDifferences" ]
linearandnonlinear = ["LinearSolve", "NonlinearSolve", "Optim", "SparsityDetection"]
symbolic_comps = ["Symbolics", "SymPy"]

packages = [utilities; plotting; data_manip]

Pkg.add(packages)

# create_sysimage(packages; sysimage_path="./MySystemImage.dll")
