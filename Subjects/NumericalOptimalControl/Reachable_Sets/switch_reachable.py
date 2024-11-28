import numpy as np
import matplotlib.pyplot as plt

x0 = 0
y0 = 0
theta0 = np.pi/2

vp = 1
up = 1

T = 10 # Point upto which the reachabel set is to be drawn
dt = 0.01
t_max = 2*np.pi/(vp*up)
no_iter = np.int(t_max/dt)

xf_plus = np.zeros([no_iter])
yf_plus = np.zeros([no_iter])

xf_minus = np.zeros([no_iter])
yf_minus = np.zeros([no_iter])

xf_plus_minus = np.zeros([no_iter])
yf_plus_minus = np.zeros([no_iter])


for i in range(0, no_iter):
    t1 = i*dt

    xf_plus[i] = x0 + (np.sin(theta0 + up*t1) - np.sin(theta0))/up + vp*np.cos(theta0 + up*t1)*(T - t1)
    yf_plus[i] = y0 - (np.cos(theta0 + up*t1) - np.cos(theta0))/up + vp*np.sin(theta0 + up*t1)*(T - t1)

    xf_minus[i] = x0 - (np.sin(theta0 - up*t1) - np.sin(theta0))/up + vp*np.cos(theta0 - up*t1)*(T - t1)
    yf_minus[i] = y0 + (np.cos(theta0 - up*t1) - np.cos(theta0))/up + vp*np.sin(theta0 - up*t1)*(T - t1)

    xf_plus_minus[i] = x0 + (np.sin(theta0 + up*t1) - np.sin(theta0))/up  - (np.sin(theta0 + up*t1 - up*(T-t1)) - np.sin(theta0 +
                                                                                                             up*t1))/up
    yf_plus_minus[i] = y0 - (np.cos(theta0 + up*t1) - np.cos(theta0))/up  + (np.cos(theta0 + up*t1 - up*(T-t1)) -
                                                                             np.cos(theta0 + up*t1))/up

plt.grid()
plt.plot(xf_plus, yf_plus)
plt.plot(xf_minus, yf_minus)
plt.axis('equal')
# plt.plot(xf_plus_minus, yf_plus_minus)
plt.show()
