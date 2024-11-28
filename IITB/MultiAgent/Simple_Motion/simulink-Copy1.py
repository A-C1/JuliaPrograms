import math as mt
import numpy as np

#******************************************************************
#******************************************************************
#******************************************************************

class Dynamics:

    """Docstring for MyClass. """

    step_size = 0.01
    initial_time = 0
    final_time = 10
    time = initial_time
    flag = 0
    no_iter = int((final_time-initial_time)/step_size)

    def __init__(self, init_state):
        """TODO: to be defined1. """
        self.init_state = np.array(init_state)
        self.current_state = self.init_state
        self.sys_dim = np.size(self.init_state)
        self.states = np.zeros([self.sys_dim, self.no_iter])

    def solver(self, dyn):
        x = self.current_state
        u = self.input_sys()
        t = self.time

        k1 = self.step_size * dyn(x, t, u)
        k2 = self.step_size * dyn(x+k1/2, t+self.step_size/2, u)
        k3 = self.step_size * dyn(x+k2/2, t+self.step_size/2, u)
        k4 = self.step_size * dyn(x+k3, t+self.step_size, u)

        self.current_state += 1 / 6 * (k1 + 2 * k2 + 2 * k3 + k4)
        self.current_state += k1

        if self.flag == 1:
            self.time += self.step_size

    def update_state(self, observed_state):
        self.observed_state = np.array(observed_state)
        self.solver(self.dynamics)
        return self.current_state


