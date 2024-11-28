# Generating the training dataset
using LinearAlgebra, GLMakie

iter = 2000
y = zeros(iter)
yd = zeros(iter)
u = zeros(iter)
x = zeros(iter,2)

for i = 1:iter-1
    u[i] = 2 * rand()-1                            # random input between -1 and 1
    y[i+1] = ( y[i] / (1+y[i]^2) ) + u[i]^3        # y is the input for calculation of next state
    yd[i] = y[i+1]                                 # Output of System for ith instant inputs
end

for i = 2:iter
    x[i,1] = u[i]                                  # For Convinince inputs are stored in x
    x[i,2] = y[i]
end


fig1, ax1, sc1 = scatter(u, yd)


## Initializing the weights and other parametrs of the NN

n0 = 3         # No of inputs/input neurons
n1 = 15        # no. of Neurons in the first layer
n2 = 1         # No. of Outputs

w = zeros(n1,n0+1)   # weights between hidden and input layer, hidden layers = 15
W = zeros(1,n1+1)    # weights between hidden and output layer

for i = 1:n1
    w[i,1] = (2*rand()-1) # randomly initialize the weights
    w[i,2] = (2*rand()-1) # randomly initialize the weights
    w[i,3] = (2*rand()-1) # randomly initialize the weights
    w[i,4] = (2*rand()-1) # randomly initialize the weights
end

for i=1:n1+1
    W[i] = (2*rand()-1)   # randomly initialize the weights
end

lr = 0.1    # learning rate
epoch = 100 # no. of epochs
p = 1       # p is the index of each epoch


# Training the NN
y2 = zeros(iter)
y2[1] = y[1]
y_act = zeros(iter)
h = zeros(n1)
v = zeros(n1+1)
del1 = zeros(n1)
mse1 = zeros(epoch)
global mse = 0     # mean square error for each iterartion is stored in this variable

while ( p <= epoch )

for j = 1:iter-1   # j is the index of each pattern
    # Forward evaluation of Neural Network
    for i = 1:n1
        h[i] = w[i,1] * x[j,1] + w[i,2] * x[j,2] + w[i,3]
        v[i] = (exp(h[i]) - exp(-h[i])) / (exp(h[i]) + exp(-h[i]))
    end
    v[n1+1]=1

    H = 0
    for i=1:n1+1
        H=H+W[i]*v[i]
    end

    y_act[j] = H
    y2[j+1] = H

    mse = mse + 0.5 * ( yd[j] - y_act[j] ) * ( yd[j] - y_act[j] ) / iter    #update of weights

    # Calculation of dels and weight update by backpropogation

    del2 = ( yd[j] - y_act[j] )

    for i = 1:(n1+1)
        W[i] = W[i] + lr * del2 * v[i]
    end

    for i = 1:n1
        del1[i] = (1-v[i]^2) * del2 * W[i]
    end

    for i = 1:n1
        w[i,1] = w[i,1] + lr*del1[i] * x[j,1]
        w[i,2] = w[i,2] + lr*del1[i] * x[j,2]
        w[i,3] = w[i,3] + lr*del1[i]
    end
end

    mse1[p] = mse
    global mse = 0
    global p=p+1
end

fig2, ax2, li2 = lines(yd)
lines!(y_act)


fig3, ax3, li3 = lines(mse1)


## plot actual test data
iter_t = 1000                          # No. of test data set
y[1]=0                                # Initial condition

for i = 1:iter_t-1
    u[i] = sin( 0.02 * i )                     # Test Input Data
    y[i+1] = ( y[i] / (1+y[i]^2) ) + u[i]^3    # y is the input for calculation of next state
    yd[i] = y[i]                               # Output of System for ith instant inputs
end

for i = 1:iter_t                             # Storing inputs in x for convinience
    x[i,1] =  u[i]
    x[i,2] =  y[i]
end



# Plot using Neural Network
y_act[1] = y[1]
e = zeros(iter_t)

for j=1:iter_t-1
    for i=1:n1
        h[i] = w[i,1] * x[j,1] + w[i,2] * x[j,2] + w[i,3]
        v[i] = ( exp(h[i]) - exp(-h[i]) ) / ( exp(h[i]) + exp(-h[i]) )
    end

    v[n1+1] = 1

    H = 0

    for i = 1:n1+1
        H = H + W[i] * v[i]
    end

    y_act[j+1] = H

    e[j] = ( y_act[j]-yd[j] ) * ( y_act[j]-yd[j] )
end


fig4 , ax4, li4 = lines(yd[1:iter_t])
lines!(ax4, y_act[1:iter_t])


# RMS Error

e1 = 0
for i=1:iter_t
    global e1 = e1 + e[i]
end

rms_err = sqrt(e1/iter)
