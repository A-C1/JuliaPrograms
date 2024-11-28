using Flux
using Flux: train!

# Generate traiining data and test data
actual(x) = 4x + 2

x_train, x_test = collect(0:5)', collect(6:10)'
y_train, y_test = actual.(x_train), actual.(x_test)
data = [(x_train, y_train)]

# Build model to make predictions
model = Dense(1, 1)
@show model.weight
@show model.bias

predict = Dense(1, 1)
predict(x_train)
println(predict.weight, predict.bias)
parameters = params(predict)

# Training the model
loss(x, y) = Flux.Losses.mse(predict(x), y)
loss(x_train, y_train)

opt = Descent()

for epoch in 1:200
	train!(loss, parameters, data, opt)
end

@show loss(x_train, y_train)
@show parameters

@show pred_values = predict(x_test)
@show actual_values = y_test

