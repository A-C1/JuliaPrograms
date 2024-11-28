import numpy as np
import matplotlib.pyplot as plt
import tangfunc_const as tang

def plot_reach(initial_state, v_max, u_max, figure_no, plus, minus, plus_minus,
        minus_plus, no_iter):
    x0 = initial_state[0]
    y0 = initial_state[1]
    theta0 = initial_state[2]

    vp = v_max
    up = u_max

    xf_plus = np.zeros([no_iter])
    yf_plus = np.zeros([no_iter])

    xf_minus = np.zeros([no_iter])
    yf_minus = np.zeros([no_iter])

    xf_plus_minus = np.zeros([no_iter])
    yf_plus_minus = np.zeros([no_iter])

    
    dt = 0.01;
    for i in range(0, no_iter):
        t1 = i*dt

        xf_plus[i] = x0 + (np.sin(theta0 + vp*up*t1) - np.sin(theta0))/up + vp*np.cos(theta0 + vp*up*t1)*(T - t1)
        yf_plus[i] = y0 - (np.cos(theta0 + vp*up*t1) - np.cos(theta0))/up + vp*np.sin(theta0 + vp*up*t1)*(T - t1)

        xf_minus[i] = x0 - (np.sin(theta0 - vp*up*t1) - np.sin(theta0))/up + vp*np.cos(theta0 - vp*up*t1)*(T - t1)
        yf_minus[i] = y0 + (np.cos(theta0 - vp*up*t1) - np.cos(theta0))/up + vp*np.sin(theta0 - vp*up*t1)*(T - t1)
    
        xf_plus_minus[i] = x0 + (np.sin(theta0 + up*t1) - np.sin(theta0))/up  - (np.sin(theta0 + up*t1 - up*(T-t1)) - np.sin(theta0 +
                                                                                                                         up*t1))/up
        yf_plus_minus[i] = y0 - (np.cos(theta0 + up*t1) - np.cos(theta0))/up  + (np.cos(theta0 + up*t1 - up*(T-t1)) -
                                                                             np.cos(theta0 + up*t1))/up
    plt.figure(figure_no)
    if plus == 1:
        plt.plot(xf_plus, yf_plus)
    if minus == 1:
        plt.plot(xf_minus, yf_minus)
    if plus_minus == 1:
        plt.plot(xf_plus_minus, yf_plus_minus)


T = 30.7
dt = 0.01


x0_p = 0
y0_p = 0
theta0_p = np.pi/2

v_p = 2.0
u_p = 0.2

t1 = 2*np.pi/(v_p*u_p)
no_iter = np.int(t1/dt)
plot_reach([x0_p, y0_p, theta0_p], v_p, u_p, 1, 1, 1, 0, 0, no_iter)
plt.axis('equal')
plt.grid(True)


x0_e = 0
y0_e = -11
theta0_e = -np.pi/2

v_e = 1.1
u_e = 0.18

t1 = 2*np.pi/(v_e*u_e)
no_iter = np.int(t1/dt)
plot_reach([x0_e, y0_e, theta0_e], v_e, u_e, 1, 1, 1, 0, 0, no_iter)
plt.axis('equal')
plt.grid(True)
tang.plot_circle(0, 0, 1/u_p)
tang.plot_circle(x0_e, y0_e, 1/u_e)


plt.show()
