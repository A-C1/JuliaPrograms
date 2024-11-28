# Generating the training dataset
using LinearAlgebra, Plots

iter = 2000
y = zeros(iter)
yd = zeros(iter)
u = zeros(iter)
x = zeros(5, iter)

f(x1,x2,x3,x4,x5) = (x1*x2*x3*x5*(x3-1)+x4)/ (1 + x3^2 +x2^2)

function relu(x)
	if x > 0.0
		return x
	else
		return 0.0
	end
end

function reluDer(x)
	if x > 0.0
		return 1.0
	else
		return 0.0
	end
end

for i = 3:iter-1
    u[i] = 2 * rand()-1                            # random input between -1 and 1
    y[i+1] = f(y[i],y[i-1],y[i-2],u[i],u[i-1])       # y is the input for calculation of next state
    yd[i] = y[i+1]                                  # Output of System for ith instant inputs
end

# for i = 3:iter-1
#     a1 = 2 * rand()-1                            # random input between -1 and 1
#     a2 = 2 * rand()-1                            # random input between -1 and 1
#     a3 = 2 * rand()-1                            # random input between -1 and 1
#     a4 = 2 * rand()-1                            # random input between -1 and 1
#     a5 = 2 * rand()-1                            # random input between -1 and 1
#     u[i] = a4
#     y[i+1] = f(a1,a2,a3,a4,a5)       # y is the input for calculation of next state
#     yd[i] = y[i+1]                                  # Output of System for ith instant inputs
# end

for i = 3:iter
    x[1,i] = u[i]                                  # For Convinince inputs are stored in x
    x[2,i] = u[i-1]
    x[3,i] = y[i]
    x[4,i] = y[i-1]
    x[5,i] = y[i-2]
end

fig1 = plot()
display(scatter!(fig1, u, yd))

## Initializing the weights and other parametrs of the NN


n0 = 5         # No of inputs/input neurons
n1 = 10        # no. of Neurons in the first layer
n2 = 10        # No. of Neurons in the second layer
n3 = 1         # No. of Outputs

W1 = 2*rand(n1,n0) .- 1    # weights between hidden and input layer, hidden layers = 15
W2 = 2*rand(n2,n1) .- 1    # weights between hidden and output layer
W3 = 2*rand(n3,n2) .- 1    # weights between hidden and output layer


lr = 0.001      # learning rate
epoch = 2000   # no. of epochs
p = 1          # p is the index of each epoch


## Training the NN
y2 = zeros(iter)
y2[1] = y[1]
y_act = zeros(iter)

h1 = zeros(n1)
v1 = zeros(n1)
b1 = 2*rand(n1) .- 1
del1_temp = zeros(n1)
del1 = zeros(n1)

h2 = zeros(n2)
v2 = zeros(n2)
b2 = 2*rand(n2) .- 1
del2_temp = zeros(n2)
del2 = zeros(n2)

h3 = zeros(n3)
v3 = zeros(n3)
b3 = 2*rand(n3) .- 1
del3_temp = zeros(n3)
del3 = zeros(n3)

mse1 = zeros(epoch)
global mse = 0     # mean square error for each iterartion is stored in this variable

while ( p <= epoch )
for j = 1:iter-1   # j is the index of each pattern
    # Forward evaluation of Neural Network
    global lr,W1, W2, W3, h1, b1, v1, del1_temp, del1, h2, v2, b2, del2, del2_temp
    global h3, v3, b3, del3, del3_temp
    # Layer 1
    h1 = W1*x[:,j] + b1
    v1 = relu.(h1)
    #Layer 2
    h2 = W2*v1 + b2
    v2 = relu.(h2)
    # Layer 3
    H = W3*v2 + b3

    #Storing Values
    y_act[j] = H[1]
    y2[j+1] = H[1]
    mse = mse + 0.5 * ( yd[j] - y_act[j] ) * ( yd[j] - y_act[j] ) / iter    #update of weights

    # Calculation of dels and weight update by backpropogation
    # Layer 3 weight and bais update
    del3[1] = ( yd[j] - y_act[j] )
    W3 = W3 + lr*del3*v2'
    b3 = b3 + lr*del3

    # Layer 2 weight update
    del2_temp =   (W3'*del3)
    del2 =   del2_temp .* reluDer.(v2)
    W2 = W2 + lr*del2*v1'
    b2 = b2 + lr*del2

    # Layer 1 weight update
    del1_temp =   (W2'*del2)
    del1 =   del1_temp .* reluDer.(v1)
    W1 = W1 + lr*del1*x[:,j]'
    b1 = b1 + lr*del1
end

    mse1[p] = mse
    global mse = 0
    global p=p+1
end

fig2 = plot()
display(plot!(fig2, yd))
display(plot!(fig2, y_act))


fig3 = plot()
display(plot!(mse1))


## plot actual test data


iter_t = iter                          # No. of test data set
y[1]=0                                # Initial condition

for i = 3:iter_t-1
    if i <= 500
        u[i] = sin( 2*pi*i/250)                     # Test Input Data
    else
        u[i] = 0.8*sin(2*pi*i/250) + 0.2*sin(2*pi*i/25)
    end

    y[i+1] = f(y[i],y[i-1],y[i-2],u[i],u[i-1])    # y is the input for calculation of next state
    yd[i] = y[i]                               # Output of System for ith instant inputs
end

for i = 3:iter_t                             # Storing inputs in x for convinience
    x[1,i] =  u[i]
    x[2,i] =  u[i-1]
    x[3,i] =  y[i]
    x[4,i] =  y[i-1]
    x[5,i] =  y[i-2]
end



# Plot using Neural Network
y_act[1] = y[1]
e = zeros(iter_t)

for j=1:iter_t-1
    global lr,W1, W2, W3, h1, b1, v1, del1_temp, del1, h2, v2, b2, del2, del2_temp
    global h3, v3, b3, del3, del3_temp
    # Layer 1
    h1 = W1*x[:,j] + b1
    v1 = relu.(h1)
    #Layer 2
    h2 = W2*v1 + b2
    v2 = relu.(h2)
    # Layer 3
    H = W3*v2 + b3

    #Storing Values
    y_act[j] = H[1]

    e[j] = ( y_act[j]-yd[j] ) * ( y_act[j]-yd[j] )
end


fig4 = plot(yd[1:iter_t])
display(plot!(fig4, y_act[1:iter_t]))


# RMS Error
e1 = 0.0
for i=1:iter_t
    global e1 = e1 + e[i]
end

rms_err = sqrt(e1/iter)
