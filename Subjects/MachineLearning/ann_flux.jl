using Flux, Statistics
using Flux.Data: DataLoader
using Flux: onehotbatch, onecold, @epochs
using Flux.Losses:logitcrossentropy
using Base: @kwdef
using MLDatasets

function getdata(args, device)
	ENV["DATADEPS_ALWAYS_ACCEPT"] = "true"

	# Loading Dataset
	

end