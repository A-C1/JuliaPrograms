import numpy as np
import matplotlib.pyplot as plt

x0 = 0
y0 = 0
theta0 = np.pi/2

vp = 1
up = 1

T = 20
dt = 0.01
t_rev = 2*np.pi/(vp*up)
no_iter = np.int(t_rev/dt)

xf_plus = np.zeros([no_iter])
yf_plus = np.zeros([no_iter])

xf_minus = np.zeros([no_iter])
yf_minus = np.zeros([no_iter])

xf_plus1 = np.zeros([no_iter**2])
yf_plus1 = np.zeros([no_iter**2])


for i in range(0, no_iter):
    t1 = 0
    for j in range(0, no_iter):
        t2 = j*dt

        xf_plus1[j*no_iter+i] = x0 + (np.sin(theta0 + vp*up*t1) - np.sin(theta0))/up + vp*np.cos(theta0 + vp*up*t1)*(t2 - t1) -\
            (np.sin(theta0 + vp*up*(t1+t2-T)) - np.sin(theta0+vp*up*t1))/up
        yf_plus1[j*no_iter+i] = y0 - (np.cos(theta0 + vp*up*t1) - np.cos(theta0))/up + vp*np.sin(theta0 + vp*up*t1)*(t2 - t1) +\
            (np.cos(theta0 + vp*up*(t1+t2-T)) - np.cos(theta0+vp*up*t1))/up


    t1 = i*dt
    xf_plus[i] = x0 + (np.sin(theta0 + vp*up*t1) - np.sin(theta0))/up + vp*np.cos(theta0 + vp*up*t1)*(T - t1)
    yf_plus[i] = y0 - (np.cos(theta0 + vp*up*t1) - np.cos(theta0))/up + vp*np.sin(theta0 + vp*up*t1)*(T - t1)

    xf_minus[i] = x0 - (np.sin(theta0 - vp*up*t1) - np.sin(theta0))/up + vp*np.cos(theta0 - vp*up*t1)*(T - t1)
    yf_minus[i] = y0 + (np.cos(theta0 - vp*up*t1) - np.cos(theta0))/up + vp*np.sin(theta0 - vp*up*t1)*(T - t1)

plt.grid()
plt.axis('equal')
plt.plot(xf_plus1, yf_plus1)
plt.plot(xf_plus, yf_plus)
plt.plot(xf_minus, yf_minus)
plt.show()
