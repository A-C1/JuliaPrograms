from simulink import Dynamics
import numpy as np
import tangfunc_const as tang

vl = 1  # Velocity of leader
ul = 2  # Turning input of leader

class AgentData:
    def __init__(self, identity, state, param):
        self.identity = identity  # Identity assigned to follower
        self.state = state  # state of the agent
        self.param = param  # parameters used in dynamics. Currently passed as
                            # an array
        self.depth_flag = 0


class SimpleLeader(Dynamics):

    """This class describes a leader and its various properties"""
    leaders_count = -1  # Leaders assigned negative identity
    sim_param = None

    def __init__(self, init_state):
        """Initializes various data """
        Dynamics.__init__(self, init_state, SimpleLeader.sim_param)
        # The data variable is of the type agent_data
        self.data = AgentData(SimpleLeader.leaders_count, init_state,
                              [vl, ul])
        SimpleLeader.leaders_count -= 1 # Decreaments the follower count
                                        # whenever a follower is created


    def dynamics(self, x, t, u):
        """This function defines dynamics of an agent"""
        
        x_dot =  vl * np.cos(x[2])
        y_dot =  vl * np.sin(x[2])
        theta_dot = vl * u * np.sin(t) 

        f_x = np.array([x_dot, y_dot, theta_dot])
        return f_x


    def input_sys(self, leaders, followers):
        """This function defines the input of the leaders"""
        xn = self.current_state
        xo = np.array([100, 500, np.pi / 2])

        "Maybe I should pass a custom function here with simulator"
        [up_t, ue_t, matrix] = tang.calc_input(vl, ul, xn,
                                               0.3, 0.3, xo)
        u = up_t
        return u


