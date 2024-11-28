from simulink import Dynamics
import numpy as np
import matplotlib.pyplot as plt

#******************************************************************
#******************************************************************
#******************************************************************


class SimpleFollower(Dynamics):

    """Docstring for Simple. """

    def __init__(self, init_state):
        """TODO: to be defined1. """
        Dynamics.__init__(self, init_state)

    def input_sys(self):
        xn = self.current_state  # Markovian Systems this info sufficient
        xo = self.observed_state
        u = np.arctan2(xo[1]-xn[1], xo[0]-xn[0])
        return u

    def dynamics(self, x, t, u):
        x1 = np.cos(u)
        y1 = np.sin(u)
        f_x = np.array([x1, y1])
        return f_x

        
#******************************************************************
#******************************************************************
#******************************************************************


class SimpleLeader(Dynamics):

    """Docstring for Simple. """

    def __init__(self, init_state):
        """TODO: to be defined1. """
        Dynamics.__init__(self, init_state)

    def input_sys(self):
        xn = self.current_state
        xo = self.observed_state
        u = np.arctan2(xn[1]-xo[1], xn[0]-xo[0])
        return u

    def dynamics(self, x, t, u):
        x1 = 0.2*np.cos(u)
        y1 = 0.2*np.sin(u)
        f_x = np.array([x1, y1])
        return f_x



Dynamics.initial_time = 0
Dynamics.final_time = 10
Dynamics.step_size = 0.01


# Create agents with initial Conditions
a0 = SimpleLeader([2., 2])
a1 = SimpleFollower([0., 0])
a2 = SimpleFollower([4., 0])
a3 = SimpleFollower([-1., -2])
a4 = SimpleFollower([1., -2])

no_iter = Dynamics.no_iter

# Create storing elements for agents
xs0 = np.zeros([2, no_iter])
xs1 = np.zeros([2, no_iter])
xs2 = np.zeros([2, no_iter])
xs3 = np.zeros([2, no_iter])
xs4 = np.zeros([2, no_iter])
t = np.zeros(no_iter)

t0 = 0
# Run the Simulation
for i in range(0, no_iter):
    # Updating the states being observed
    xs0[:, i] =  a0.update_state([2, 0]) 
    xs1[:, i] =  a1.update_state(a0.current_state) 
    xs2[:, i] =  a2.update_state(a0.current_state) 
    xs3[:, i] =  a3.update_state(a1.current_state) 
    xs4[:, i] =  a4.update_state(a1.current_state) 
    t[i] = t0
    # Connecting the edges
    t0 = t0 + Dynamics.step_size

    

# ipdb.set_trace()
# Plotting the results
# Plot of x-y
plt.figure(1)
plt.plot(xs0[0, :], xs0[1, :], linestyle = '--', linewidth=2.0, label = 'a0')
plt.plot(xs1[0, :], xs1[1, :], linestyle = '-.', linewidth=2.0, label = 'a1')
plt.plot(xs2[0, :], xs2[1, :], linestyle = '-.', linewidth=2.0, label = 'a2')
plt.plot(xs3[0, :], xs3[1, :], linestyle = '-.', linewidth=2.0, label = 'a3')
plt.plot(xs4[0, :], xs4[1, :], linestyle = '-.', linewidth=2.0, label = 'a4')
plt.grid()
plt.xlabel('x-position')
plt.ylabel('y-position')
plt.title('x-y graph for all agents')
plt.legend(loc='upper left', frameon=False)
#plt.savefig('/home/aditya/Dropbox/Latex_Current_Projects/Simple-Motion/xy-plot.png')
## Plot of x-y
#plt.figure(2)
#plt.plot(t, xs0[0, :], linestyle = '--', linewidth=2.0, label = 'a0')
#plt.plot(t, xs1[0, :], linestyle = '-.', linewidth=2.0, label = 'a1')
#plt.plot(t, xs2[0, :], linestyle = '-.', linewidth=2.0, label = 'a2')
#plt.plot(t, xs3[0, :], linestyle = '-.', linewidth=2.0, label = 'a3')
#plt.plot(t, xs4[0, :], linestyle = '-.', linewidth=2.0, label = 'a4')
#plt.grid()             
#plt.xlabel('Time(t)')
#plt.ylabel('x-position')
#plt.title('x-t graph for all agents')
#plt.legend(loc='upper right', frameon=False)
#plt.savefig('/home/aditya/Dropbox/Latex_Current_Projects/Simple-Motion/xt-plot.png')
## Plot of x-y
#plt.figure(3)
#plt.plot(t, xs0[1, :], linestyle = '--', linewidth=2.0, label = 'a0')
#plt.plot(t, xs1[1, :], linestyle = '-.', linewidth=2.0, label = 'a1')
#plt.plot(t, xs2[1, :], linestyle = '-.', linewidth=2.0, label = 'a2')
#plt.plot(t, xs3[1, :], linestyle = '-.', linewidth=2.0, label = 'a3')
#plt.plot(t, xs4[1, :], linestyle = '-.', linewidth=2.0, label = 'a4')
#plt.grid()
#plt.xlabel('Time(t)')
#plt.ylabel('y-position')
#plt.title('y-t graph for all agents')
#plt.legend(loc='upper left', frameon=False)
#plt.savefig('/home/aditya/Dropbox/Latex_Current_Projects/Simple-Motion/yt-plot.png')
plt.show()


# def plot_same_index(fig_num, xlabel, ylabel, title):
#     plt.figure(fig_num)
#     plt.plot(t, xs0[fig_num, :], linestyle = '--', linewidth=2.0, label = 'a0')
#     plt.plot(t, xs1[fig_num, :], linestyle = '-.', linewidth=2.0, label = 'a1')
#     plt.plot(t, xs2[fig_num, :], linestyle = '-.', linewidth=2.0, label = 'a2')
#     plt.plot(t, xs3[fig_num, :], linestyle = '-.', linewidth=2.0, label = 'a3')
#     plt.plot(t, xs4[fig_num, :], linestyle = '-.', linewidth=2.0, label = 'a4')
#     plt.grid('on')
#     plt.xlabel('Time(t)')
#     plt.ylabel('y-position')
#     plt.title('y-t graph for all agents')
#     plt.legend(loc='upper left', frameon=False)
#     # plt.savefig('/home/aditya/Dropbox/Latex_Current_Projects/Simple-Motion/yt-plot.png')
#     plt.show()
