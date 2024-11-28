import numpy as np


class Dynamics:

    """This is the Dynamics class
       It contains various solvers
       It is also the base class for any physical object """


    def __init__(self, init_state, sim_param, extra_data = None):
        """Initializes all the states"""
        self.init_state = init_state   # Initial state of the system
        self.time = sim_param.initial_time   # Variable storing the current time
        self.current_state = np.array(self.init_state)  # Current state of
                                                        # the system
        self.sys_dim = np.size(self.init_state)  # No. of states
        self.sim_param = sim_param
        self.no_iter = int((sim_param.final_time - sim_param.initial_time)  # Calculate th
                           /sim_param.step_size)                     # itereations
        self.states = np.zeros([self.sys_dim, self.no_iter]) # For storing
                                                             # Value of state
        self.extra_data = extra_data


    def solver(self, dyn, leaders=None, followers=None):
        """
            Defines the algorithm which predicts the next 
            state of the system based on current state
            and input calculated by the function input_sys. Note that the 
            function input_sys will be defined in the child class. In this
            solver interface we have used a Runge-Kutta Solver.
        """
        x = self.current_state   # Current state 
        u = self.input_sys(leaders, followers) # Input based on the current state
        t = self.time  # Current time

        # Updating the state
        k1 = self.sim_param.step_size * dyn(x, t, u)
        k2 = self.sim_param.step_size * dyn(x+k1/2, t+self.sim_param.step_size/2, u)
        k3 = self.sim_param.step_size * dyn(x+k2/2, t+self.sim_param.step_size/2, u)
        k4 = self.sim_param.step_size * dyn(x+k3, t+self.sim_param.step_size, u)
        self.current_state += 1 / 6 * (k1 + 2 * k2 + 2 * k3 + k4)

        self.time += self.sim_param.step_size


    def update_state(self, observed_state=None, leaders=None, followers=None):
        self.observed_state = np.array(observed_state)
        self.solver(self.dynamics, leaders, followers)
        # self.dynamics is a virtual function defined in the derived class
        return self.current_state
