import numpy as np
import matplotlib.pyplot as plt

# generating the training dataset


iter_t = 1000                  # No. of training data samples
y = np.zeros([iter_t])         # Output   
yn = np.zeros([iter_t])        # Normalized Output
x = np.zeros([iter_t, 2])      # Input as feedback
u = np.zeros([iter_t])         # Input
yd = np.zeros([iter_t])        # Auxillary Variable

for i in range(-1, iter_t-1):
    u[i] = 2 * np.random.rand(1) - 1         # Random input between -1 and 1
    y[i] = 3 * np.random.rand(1) - 1.5       # Random input between -1 and 1
    y[i+1] = (y[i] / (1+y[i]**2)) + u[i]**3  # Actual output at next instant
    yd[i] = y[i+1]                           # Change of index for convinience

maxvalue = 1.5
minvalue = -1.5

for i in range(0, iter_t):
    yn[i] = 2 * (y[i] - minvalue)/(maxvalue - minvalue)-1


for i in range(0, iter_t):
    x[i, 0] = u[i]                              # x is input vector
    x[i, 1] = yn[i]

# Plotting training data
plt.figure(0)
plt.plot(u, y, '.')


# Intializing RBFN


n_c = 15           # No of RBFN centers
n_i = 2            # No of Inputs
C = np.random.random([n_c, n_i])  # Creating & Initializing centers
W = np.zeros([n_c+1])
# Initializing weights randomly
for i in range(0, n_c+1):
    W[i] = 0.2*(np.random.rand(1)-1)

lr_c = 0.3         # learning rate for centers
lr_w = 0.1       # learning rate for weights
epoch = 500       # network definition

sigma = 0.2        # width of radial basis


# Training the RBFN
p = 1
r = np.zeros([n_c])
z = np.zeros([n_c])
phi = np.zeros([n_c+1])
y_act = np.zeros([iter_t])
while (p <= epoch):
    for j in range(0, iter_t):  # j is the index of each pattern
        #  calculating distance of centers from input and basis output
        for i in range(0, n_c):
            r[i] = (C[i, 0] - x[j, 0])*(C[i, 0] - x[j, 0]) + (C[i, 1]-x[j, 1])\
                    * (C[i, 1] - x[j, 1])
            z[i] = np.sqrt(r[i])
            phi[i] = np.exp(-sigma*r[i])
        phi[n_c] = 1  # Bias Input
        H = 0

        for i in range(0, n_c+1):
            H = H + W[i] * phi[i]

        y_act[j] = H  # Output of RBFN

        # Update of weights
        delta = (yd[j] - y_act[j])
        for i in range(0, n_c+1):
            W[i] = W[i] + lr_w * delta * phi[i]

        # # Update Of centers
        # for i in range(0, n_c):
        #     for k in range(0, n_i):
        #         C[i, k] = C[i, k] + lr_c * delta * W[i] * phi[i] * \
        #                 (x[j, k]-C[i, k]) / (sigma*sigma)

    p = p+1

plt.figure(2)
plt.plot(yd)
plt.plot(y_act, 'r')


# plot actual test data
y[1] = 0

for i in range(0, iter_t-1):
    u[i] = np.sin(0.01*i)
    y[i+1] = (y[i] / (1 + y[i]**2)) + u[i]**3
    yd[i] = y[i]


plt.figure(3)
plt.plot(yd)

for i in range(0, iter_t):
    yn[i] = 2 * (y[i] - minvalue) / (maxvalue-minvalue) - 1

for i in range(0, iter_t):
    x[i, 0] = u[i]
    x[i, 1] = yn[i]


# Plot using RBFN

e = np.zeros([iter_t])
for j in range(0, iter_t-1):  # j is the index of each pattern

    # calculating distance of centers from input and basis output
    for i in range(0, n_c):
        r[i] = (C[i, 0]-x[j, 0])**2 + (C[i, 1]-x[j, 1])**2
        z[i] = np.sqrt(r[i])
        phi[i] = np.exp(-sigma*r[i])

    phi[n_c] = 1  # Bias Input

    H = 0

    for i in range(0, n_c+1):
        H = H + W[i] * phi[i]

    y_act[j+1] = H  # Output of RBFN

    e[j] = (y_act[j]-yd[j])**2


plt.plot(y_act, 'r')


# RMS Error


e1 = 0
for i in range(0, iter_t):
    e1 = e1 + e[i]

rms_err = np.sqrt(e1/iter_t)

plt.show()
