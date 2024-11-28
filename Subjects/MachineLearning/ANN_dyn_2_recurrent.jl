# Generating the training dataset
using LinearAlgebra, Plots

iter = 1000
y = zeros(iter)
yd = zeros(iter)
u = zeros(iter)

f(x1,x2,x3,x4,x5) = (x1*x2*x3*x5*(x3-1)+x4)/ (1 + x3^2 +x2^2)

for i = 3:iter-1
    u[i] = 2 * rand()-1                            # random input between -1 and 1
    y[i+1] = f(y[i],y[i-1],y[i-2],u[i],u[i-1])       # y is the input for calculation of next state
    yd[i] = y[i+1]                                  # Output of System for ith instant inputs
end

fig1 = plot()
scatter!(fig1, u, yd)

## Initializing the weights and other parametrs of the NN
n0 = 1         # No of inputs/input neurons
n1 = 5        # no. of Neurons in the first layer
n2 = 4        # No. of Neurons in the second layer
n3 = 5         # No. of Neurons in the third layer
n4 = 1         # No. of Outputs

W1 = 2*rand(n1,n0) .- 1   # weights between hidden and input layer, hidden layers = 15
W2 = 2*rand(n2,n1) .- 1    # weights between hidden and output layer
W2f = 2*rand(n2,n2) .- 1    # feedback weights between hidden and output layer
W3 = 2*rand(n3,n2) .- 1    # weights between hidden and output layer
W4 = 2*rand(n4,n3) .- 1    # weights between hidden and output layer


lr = 0.03    # learning rate
epoch = 800   # no. of epochs
p = 1        # p is the index of each epoch
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
v2_prev = zeros(n2)
b2 = 2*rand(n2) .- 1
del2_temp = zeros(n2)
del2 = zeros(n2)

h3 = zeros(n3)
v3 = zeros(n3)
b3 = 2*rand(n3) .- 1
del3_temp = zeros(n3)
del3 = zeros(n3)

h4 = zeros(n4)
v4 = zeros(n4)
b4 = 2*rand(n4) .- 1
del4_temp = zeros(n4)
del4 = zeros(n4)

mse1 = zeros(epoch)
global mse = 0     # mean square error for each iterartion is stored in this variable

while ( p <= epoch )
for j = 1:iter-1   # j is the index of each pattern
    # Forward evaluation of Neural Network
    global lr,W1, W2, W3, h1, b1, v1, del1_temp, del1, h2, v2, b2, del2, del2_temp
    global h3, v3, b3, del3, del3_temp, W2f, v2_prev
    global h4, v4, b4, del13_temp, del3, W4
    # Layer 1
    h1 = W1*u[j] + b1
    v1 = tanh.(h1)
    #Layer 2
    h2 = W2*v1 + W2f*v2_prev + b2
    v2 = tanh.(h2)
    # Layer 3
    h3 = W3*v2 + b3
    v3 = tanh.(h3)
    # Layer 4
    H = W4*v3 + b4

    #Storing Values
    y_act[j] = H[1]
    y2[j+1] = H[1]
    mse = mse + 0.5 * ( yd[j] - y_act[j] ) * ( yd[j] - y_act[j] ) / iter    #update of weights

    # Calculation of dels and weight update by backpropogation
    # Layer 4 weight and bais update
    del4[1] = ( yd[j] - y_act[j] )
    W4 = W4 + lr*del4*v3'
    b4 = b4 + lr*del4

    # Layer 3 weight and bais update
    del3_temp =   (W4'*del4)
    del3 =   del3_temp .* (1 .- v3.^2)
    W3 = W3 + lr*del3*v2'
    b3 = b3 + lr*del3

    # Layer 2 weight and bias update
    del2_temp =   (W3'*del3)
    del2 =   del2_temp .* (1 .- v2.^2)
    W2 = W2 + lr*del2*v1'
    b2 = b2 + lr*del2
    W2f = W2f + lr*del2*v2_prev'

    # Layer 1 weight and bias update
    del1_temp =   (W2'*del2)
    del1 =   del1_temp .* (1 .- v1.^2)
    W1 = W1 + lr*del1*u[j]'
    b1 = b1 + lr*del1

    v2_prev = v2
end

    mse1[p] = mse
    global mse = 0
    global p=p+1
end

fig2 = plot()
plot!(fig2, yd)
plot!(fig2, y_act)


fig3 = plot()
plot!(mse1)


## plot actual test data


iter_t = 1000                          # No. of test data set
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

# Plot using Neural Network
y_act[1] = y[1]
e = zeros(iter_t)

for j=1:iter_t-1
    global lr,W1, W2, W3, h1, b1, v1, del1_temp, del1, h2, v2, b2, del2, del2_temp
    global h3, v3, b3, del3, del3_temp, W2f, v2_prev
    global h4, v4, b4, del13_temp, del3, W4
    # Layer 1
    h1 = W1*u[j] + b1
    v1 = tanh.(h1)
    #Layer 2
    h2 = W2*v1 + W2f*v2_prev + b2
    v2 = tanh.(h2)
    # Layer 3
    h3 = W3*v2 + b3
    v3 = tanh.(h3)
    # Layer 4
    H = W4*v3 + b4

    #Storing Values
    y_act[j] = H[1]

    e[j] = ( y_act[j]-yd[j] ) * ( y_act[j]-yd[j] )
end


fig4 = plot(yd[1:iter_t])
display(plot!(fig4, y_act[1:iter_t]))


# RMS Error

e1 = 0
for i=1:iter_t
    global e1 = e1 + e[i]
end

rms_err = sqrt(e1/iter)
