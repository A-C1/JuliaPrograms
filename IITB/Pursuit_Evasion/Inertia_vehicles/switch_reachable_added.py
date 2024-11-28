import numpy as np
import matplotlib.pyplot as plt

x0 = 0
y0 = 0
u0 = -5
w0 = -5

ap = 2

T = 5
dtheta = 0.01
no_iter = np.int(np.pi*2/dtheta)

xf = np.zeros([no_iter])
yf = np.zeros([no_iter])


for i in range(0, no_iter):
    theta = i*dtheta
    xf[i] = x0 + u0*T + ap*np.cos(theta)*(T**2)
    yf[i] = y0 + w0*T + ap*np.sin(theta)*(T**2)



plt.grid()
plt.axis('equal')
plt.plot(xf, yf)
plt.show()
