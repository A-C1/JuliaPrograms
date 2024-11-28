import math as mt
import numpy as np
import matplotlib.pyplot as plt
import ipdb


class Dynamics:

    """Docstring for MyClass. """

    def __init__(self, init_state):
        """TODO: to be defined1. """
        self.h = 0.01
        self.time = 0
        self.init_state = init_state
        self.current_state = init_state

    def solver(self, dyn):
        k1 = self.h * dyn(0, np.zeros([2]))
        k2 = self.h * dyn(self.h/2, k1/2)
        k3 = self.h * dyn(self.h/2, k2/2)
        k4 = self.h * dyn(self.h, k3)

        self.current_state += 1 / 6 * (k1 + 2 * k2 + 2 * k3 + k4)

    def update_state(self, observed_state):
        self.observed_state = observed_state
        self.solver(self.dynamics)
        # k1 = self.h * self.dynamics(0, np.zeros([2]))
        # k2 = self.h * self.dynamics(self.h/2, k1/2)
        
        # k3 = self.h * self.dynamics(self.h/2, k2/2)
        # k4 = self.h * self.dynamics(self.h, k3)

        # self.current_state += 1 / 6 * (k1 + 2 * k2 + 2 * k3 + k4)

        return self.current_state
    # For loop ends


class SimpleFollower(Dynamics):

    """Docstring for Simple. """

    def __init__(self, init_state):
        """TODO: to be defined1. """
        Dynamics.__init__(self, init_state)
        self.observed = np.zeros(2)
        self.input = np.zeros(1)

    def input_sys(self):
        xn = self.current_state
        xo = self.observed_state
        u = np.arctan2(xo[1]-xn[1], xo[0]-xn[0])
        return u

    def dynamics(self, t_add, s_add):
        un = self.input_sys()
        xn = self.current_state + s_add
        tn = self.time + t_add

        x1 = np.cos(un)
        y1 = np.sin(un)
        x_o = np.array([x1, y1])
        return x_o

        
class SimpleLeader(Dynamics):

    """Docstring for Simple. """

    def __init__(self, init_state):
        """TODO: to be defined1. """
        Dynamics.__init__(self, init_state)
        self.observed = np.zeros(2)
        self.input = np.zeros(1)

    def input_sys(self):
        xn = self.current_state
        xo = self.observed_state
        u = np.arctan2(xn[1]-xo[1], xn[0]-xo[0])
        return u

    def dynamics(self, t_add, s_add):
        un = self.input_sys()
        xn = self.current_state + s_add
        tn = self.time + t_add

        x1 = 0.2*np.cos(un)
        y1 = 0.2*np.sin(un)
        x_o = np.array([x1, y1])
        return x_o

t0 = 0
tf = 10
h = 0.01

# Give initial conditions of leaders
x0 = np.array([2., 2])
x1 = np.array([0., 0])
x2 = np.array([4., 0])
x3 = np.array([-1., -2])
x4 = np.array([1., -2])

# Create agents
a0 = SimpleLeader(x0)
a1 = SimpleFollower(x1)
a2 = SimpleFollower(x2)
a3 = SimpleFollower(x3)
a4 = SimpleFollower(x4)

no_iter = int((tf-t0)/h)

# Create storing elements for agents
xs0 = np.zeros([2, no_iter])
xs1 = np.zeros([2, no_iter])
xs2 = np.zeros([2, no_iter])
xs3 = np.zeros([2, no_iter])
xs4 = np.zeros([2, no_iter])
t = np.zeros(no_iter)

# Run the Simulation
for i in range(0, no_iter):
    # Updating the states being observed
    xs0[:, i] = x0
    xs1[:, i] = x1
    xs2[:, i] = x2
    xs3[:, i] = x3
    xs4[:, i] = x4
    t[i] = t0
    # Connecting the edges
    x0 = a0.update_state([2, 0])
    x1 = a1.update_state(x0)
    x2 = a2.update_state(x0)
    x3 = a3.update_state(x1)
    x4 = a4.update_state(x1)
    t0 = t0 + h

    

# ipdb.set_trace()
# Plotting the results
# Plot of x-y
plt.figure(1)
plt.plot(xs0[0, :], xs0[1, :], linestyle = '--', linewidth=2.0, label = 'a0')
plt.plot(xs1[0, :], xs1[1, :], linestyle = '-.', linewidth=2.0, label = 'a1')
plt.plot(xs2[0, :], xs2[1, :], linestyle = '-.', linewidth=2.0, label = 'a2')
plt.plot(xs3[0, :], xs3[1, :], linestyle = '-.', linewidth=2.0, label = 'a3')
plt.plot(xs4[0, :], xs4[1, :], linestyle = '-.', linewidth=2.0, label = 'a4')
plt.grid('on')
plt.xlabel('x-position')
plt.ylabel('y-position')
plt.title('x-y graph for all agents')
plt.legend(loc='upper left', frameon=False)
plt.savefig('/home/aditya/Dropbox/Latex_Current_Projects/Simple-Motion/xy-plot.png')
# Plot of x-y
plt.figure(2)
plt.plot(t, xs0[0, :], linestyle = '--', linewidth=2.0, label = 'a0')
plt.plot(t, xs1[0, :], linestyle = '-.', linewidth=2.0, label = 'a1')
plt.plot(t, xs2[0, :], linestyle = '-.', linewidth=2.0, label = 'a2')
plt.plot(t, xs3[0, :], linestyle = '-.', linewidth=2.0, label = 'a3')
plt.plot(t, xs4[0, :], linestyle = '-.', linewidth=2.0, label = 'a4')
plt.grid('on')             
plt.xlabel('Time(t)')
plt.ylabel('x-position')
plt.title('x-t graph for all agents')
plt.legend(loc='upper right', frameon=False)
plt.savefig('/home/aditya/Dropbox/Latex_Current_Projects/Simple-Motion/xt-plot.png')
# Plot of x-y
plt.figure(3)
plt.plot(t, xs0[1, :], linestyle = '--', linewidth=2.0, label = 'a0')
plt.plot(t, xs1[1, :], linestyle = '-.', linewidth=2.0, label = 'a1')
plt.plot(t, xs2[1, :], linestyle = '-.', linewidth=2.0, label = 'a2')
plt.plot(t, xs3[1, :], linestyle = '-.', linewidth=2.0, label = 'a3')
plt.plot(t, xs4[1, :], linestyle = '-.', linewidth=2.0, label = 'a4')
plt.grid('on')
plt.xlabel('Time(t)')
plt.ylabel('y-position')
plt.title('y-t graph for all agents')
plt.legend(loc='upper left', frameon=False)
plt.savefig('/home/aditya/Dropbox/Latex_Current_Projects/Simple-Motion/yt-plot.png')
plt.show()
