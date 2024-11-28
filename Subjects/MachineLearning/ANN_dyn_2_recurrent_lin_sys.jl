## Generating the training dataset
using LinearAlgebra, GLMakie

iter = 1000
sys_order = 4
y = zeros(iter)
yd = zeros(iter)
u = zeros(iter)
x = zeros(sys_order, iter)
A = [0.5 0 0 0; 0 0.2 0 0; 0 0 0.3 0; 0 0 0 0.4]
B = [1 1 1 1]'
C = [1 1 1 1]

function satu(u::Float64, a::Float64)::Float64
    if -a <= u <= a
        return u
    elseif u < a
        return -a
    elseif u > a
        return a
    end
end


function f(u, z, A, B, C)
    z1 = A*z + B*u
    return (C*z1)[1], z1
end

for i = 1:iter-1
    global A, B, C
    u[i] = 2 * rand()-1                            # random input between -1 and 1
    y[i+1], x[:, i+1] = f(u[i], x[:,i], A, B, C)   # y is the input for calculation of next state
    # x[:,i+1] = A*x[:,i] + B*u[i]
    # y[i+1] = (C*x[:,i+1])[1]
    yd[i] = y[i+1]                                 # Output of System for ith instant inputs
end

fig1 = Figure()
ax = Axis(fig1[1,1])
scatter!(ax, u, yd)

## Initializing the weights and other parametrs of the NN
n0 = 1         # No of inputs/input neurons
n1 = 4        # no. of Neurons in the first layer
n2 = 1         # No. of Outputs

W1 = 2*rand(n1,n0) .- 1   # weights between hidden and input layer, hidden layers = 15
W1f = 2*rand(n1,n1) .- 1    # feedback weights between hidden and output layer
W2 = 2*rand(n2,n1) .- 1    # weights between hidden and output layer


lr = 0.002   # learning rate
epoch = 2000   # no. of epochs
p = 1        # p is the index of each epoch
## Training the NN
y2 = zeros(iter)
y2[1] = y[1]
y_act = zeros(iter)

h1 = zeros(n1)
v1 = zeros(n1)
v1_prev = zeros(n1)
b1 = 2*rand(n1) .- 1
del1_temp = zeros(n1)
del1 = zeros(n1)

h2 = zeros(n2)
v2 = zeros(n2)
b2 = 2*rand(n2) .- 1
del2_temp = zeros(n2)
del2 = zeros(n2)

mse1 = zeros(epoch)
global mse = 0     # mean square error for each iterartion is stored in this variable
global a = 1.3

while ( p <= epoch )
for j = 1:iter-1   # j is the index of each pattern
    # Forward evaluation of Neural Network
    global lr,W1, W1f, W2, h1, b1, v1, v1_prev, del1_temp, del1,b2, del2, del2_temp
    global a
    # Layer 1
    h1 = W1*u[j] + W1f*v1_prev
    v1 = satu.(h1, a)
    #Layer 2
    H = W2*v1

    #Storing Values
    y_act[j] = H[1]
    y2[j+1] = H[1]
    mse = mse + 0.5 * ( yd[j] - y_act[j] ) * ( yd[j] - y_act[j] ) / iter    #update of weights

    # Calculation of dels and weight update by backpropogation
    # Layer 4 weight and bais update
    del2[1] = ( yd[j] - y_act[j] )
    W2 = W2 + lr*del2*v1'
    # b2 = b2 + lr*del2


    # Layer 2 weight and bias update
    del1_temp =   (W2'*del2)
    del1 =   del1_temp .* (1 .- v1.^2)
    W1 = W1 + lr*del1*u[j]'
    # b1 = b1 + lr*del1
    W1f = W1f + lr*del1*v1_prev'

    v1_prev = v1
end

    mse1[p] = mse
    global mse = 0
    global p=p+1
end

fig2 = Figure()
ax2 = Axis(fig2[1,1])
lines!(ax2, yd)
lines!(ax2, y_act)


fig3 = Figure()
ax3 = Axis(fig3[1,1])
display(lines!(ax3,mse1))


## plot actual test data


iter_t = iter                          # No. of test data set
y[1]=0                                # Initial condition

for i = 3:iter_t-1
    global A,B,C
    if i <= 500
        u[i] = sin( 2*pi*i/250)                     # Test Input Data
    else
        u[i] = 0.8*sin(2*pi*i/250) + 0.2*sin(2*pi*i/25)
    end

    y[i+1], x[:,i+1] = f(u[i], x[:,i], A, B, C)    # y is the input for calculation of next state
    yd[i] = y[i]                               # Output of System for ith instant inputs
end

# Plot using Neural Network
y_act[1] = y[1]
e = zeros(iter_t)

for j=1:iter_t-1
    # Forward evaluation of Neural Network
    global lr,W1, W1f, W2, h1, b1, v1, v1_prev
    # Layer 1
    h1 = W1*u[j] + W1f*v1_prev
    v1 = satu.(h1, a)
    #Layer 2
    H = W2*v1

    #Storing Values
    y_act[j] = H[1]

    e[j] = ( y_act[j]-yd[j] ) * ( y_act[j]-yd[j] )
end


fig4, ax4, li4 = lines(yd[1:iter_t])
lines!(y_act[1:iter_t])
display(fig4)


# RMS Error

e1 = 0
for i=1:iter_t
    global e1 = e1 + e[i]
end

rms_err = sqrt(e1/iter)
