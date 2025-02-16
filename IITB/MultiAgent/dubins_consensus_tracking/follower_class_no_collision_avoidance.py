from simulink import Dynamics
import numpy as np
import tangfunc_const as tang


class AgentData:
    def __init__(self, identity, state, depth_flag, 
            leader_identity, leader_flag, converge, param):
        self.identity = identity  # Identity assigned to follower
        self.state = state  # state of the agent
        self.depth_flag = depth_flag  # Value of depth flag set to infinity
        self.leader_identity = leader_identity  # identity of the local leader
        self.leader_flag = leader_flag  # leader selected by the follower agent
        self.converge_flag  = converge  # Initially false. True if the 
                                        # follower converges to the leader
        self.alligned_flag = False # Used for soft allignment
        self.alligned_timer = 0 # Used to keep time
        self.param = param  # parameters used in dynamics. Currently passed as
                            # an array
    

class SimpleFollower(Dynamics):

    """This class creates a follower and defines number of
       functions which are necessary"""
    followers_count = 0  # Counts the number of followers created 
    sim_param = None   # Contains simulations times
    comm_param = None  # parameters used for communication
    sys_param = None

    def __init__(self, init_state):
        """TODO: Initializes the values of initial state and all the flags """
        Dynamics.__init__(self, init_state, SimpleFollower.sim_param) # Intialization of variables in
                                            # base class
        # The data variable is of the type agent_data
        self.data = AgentData(SimpleFollower.followers_count, init_state,
                np.inf, np.inf, np.inf, False,
                              [SimpleFollower.sys_param.vf_max,
                               SimpleFollower.sys_param.uf_max])
        self.neighbors_followers = []  # Follower neighbors
        self.neighbors_leaders = []    # Leader Neighbors
        SimpleFollower.followers_count += 1 # Increaments the follower count
                                            # whenever a follower is created


    def dynamics(self, x, t, u):
        """This function defines dynamics of an agent"""
        vf = self.data.param[0]  # max velocity
        uf = self.data.param[1]  # max angular velocity

        x_dot = vf * np.cos(x[2])
        y_dot = vf * np.sin(x[2])  
        theta_dot = vf * u         

        f_x = np.array([x_dot, y_dot, theta_dot])

        return f_x
        

    def neighbors(self, leaders, followers):
        """This function identifies the neighbors of a follower agent"""
        self.neighbors_followers = []
        self.neighbors_leaders = []

        r = SimpleFollower.sys_param.r
        r_au = SimpleFollower.sys_param.r_au
        dt_allign = SimpleFollower.sys_param.dt_allign
        # First add the followers neighbors
        for i in range(0, len(followers)):
            if i != self.data.identity: 
                dist = np.linalg.norm(self.current_state[0:2] -
                        followers[i].current_state[0:2])
                if dist <= r:
                    self.neighbors_followers.append(followers[i].data)

        # Next add the leader neighbors
        for i in range(0, len(leaders)):
            dist_lead = np.linalg.norm(leaders[i].current_state[0:2] -
                    self.current_state[0:2])
            if dist_lead <= r:
                self.neighbors_leaders.append(leaders[i].data)


    def select_leader(self, leaders, followers):
        """TODO: Set the leader and the depth flag"""
        # Add the neighbors 
        r = SimpleFollower.sys_param.r
        r_au = SimpleFollower.sys_param.r_au
        dt_allign = SimpleFollower.sys_param.dt_allign

        self.neighbors(leaders, followers)

        if len(self.neighbors_leaders) == 1:  # If leader is within communication range
            self.data.depth_flag = 1
            self.data.leader_flag = self.neighbors_leaders[0].identity
            self.data.leader_identity = self.neighbors_leaders[0].identity 

        else:  # If leader is not within communication range
            prev_flag = np.inf  # Variable to store flag
            # Sift through all the followers
            for i in range(0, len(self.neighbors_followers)):
                # 1.followers[i].depth_flag != np.nan :
                # ensures that the agent 
                # being checked has already set its flag 
                # 2. followers[i].depth_flag <= prev_flag: 
                # The follower is selected only if it is at a lower
                # depth than the current selected follower
                if self.neighbors_followers[i].depth_flag != np.inf and \
                        self.neighbors_followers[i].depth_flag <= prev_flag:
                    self.data.leader_identity = self.neighbors_followers[i].identity
                    self.data.depth_flag = self.neighbors_followers[i].depth_flag + 1
                    self.data.leader_flag = self.neighbors_followers[i].leader_flag
                    prev_flag = self.neighbors_followers[i].depth_flag

    


    def allign_cohesion_state(self, leaders, followers):
        r = SimpleFollower.sys_param.r
        r_au = SimpleFollower.sys_param.r_au
        dt_allign = SimpleFollower.sys_param.dt_allign

        if self.data.depth_flag == 1:
            xo = self.neighbors_leaders[0].state
        else:
            # for i in range(0, len(self.neighbors_followers)):
            #     if self.neighbors_followers[i].identity ==\
            #        self.data.leader_identity:
                    # xo = self.neighbors_followers[i].state
            xo = followers[self.data.leader_identity].data.state
                
        return xo
        


    def input_sys(self, leaders, followers):
        r = SimpleFollower.sys_param.r
        r_au = SimpleFollower.sys_param.r_au
        dt_allign = SimpleFollower.sys_param.dt_allign

        xn = self.current_state
            
        # Allignment-Cohesion State

        x_allign_cohesion = self.allign_cohesion_state(leaders, followers)
        dist_allign_cohesion =  np.linalg.norm(x_allign_cohesion[0:2] - xn[0:2])


        if dist_allign_cohesion <= r_au and self.data.alligned_timer < 0.1:
            self.data.alligned_timer = dt_allign

        if self.data.alligned_timer >= 0.1:
            self.data.alligned_timer -= SimpleFollower.sim_param.step_size

        # Deciding the velocity of agent if local leader is the leader

        if self.data.leader_identity == -1 and self.data.alligned_timer > 0.1:
            self.data.converge_flag = True
            vp = self.data.param[0] = SimpleFollower.sys_param.vl_max
            up = self.data.param[1] = SimpleFollower.sys_param.ul_max
        elif self.data.leader_identity == -1 and self.data.alligned_timer <= 0.1:
            self.data.converge_flag = False
            vp = self.data.param[0] = SimpleFollower.sys_param.vf_max
            up = self.data.param[1] = SimpleFollower.sys_param.uf_max

        # Deciding the velocity of agent if local leader is the leader
        if self.data.leader_identity != -1 and self.data.alligned_timer > 0.1:
            self.data.converge_flag = True
        elif self.data.leader_identity != -1 and self.data.alligned_timer <= 0.1:
            self.data.converge_flag = False

        if self.data.leader_identity != -1 and self.data.converge_flag == True:
            if followers[self.data.leader_identity].data.converge_flag ==True:
                vp = self.data.param[0] = SimpleFollower.sys_param.vl_max
                up = self.data.param[1] = SimpleFollower.sys_param.ul_max
            else:
                vp = self.data.param[0] = SimpleFollower.sys_param.vf_max
                up = self.data.param[1] = SimpleFollower.sys_param.uf_max
        elif self.data.leader_identity != -1 and self.data.converge_flag != True:
            vp = self.data.param[0] = SimpleFollower.sys_param.vf_max
            up = self.data.param[1] = SimpleFollower.sys_param.uf_max

        # Deciding velocity of local leader
        if self.data.leader_identity == -1:
            ve =  SimpleFollower.sys_param.vl_max
            ue =  SimpleFollower.sys_param.ul_max
        else:
            if followers[0].data.converge_flag == True:
                ve = SimpleFollower.sys_param.vl_max
                ue = SimpleFollower.sys_param.ul_max
            else:
                ve = SimpleFollower.sys_param.vf_max
                ue = SimpleFollower.sys_param.uf_max

        # Deciding the input
        xo = x_allign_cohesion
        if self.data.alligned_timer > 0.1: 
            up_t = np.sign(xo[2] - xn[2])*up
        else:
            [up_t, ue_t, matrix] = tang.calc_input(vp, up, xn,
                                                   ve, ue, xo)

        # vp = self.data.param[0] = SimpleFollower.sys_param.vf_max
        # up = self.data.param[1] = SimpleFollower.sys_param.uf_max
        # up_t = np.sign(xo[2] - xn[2])*up
        return up_t




    # def repulsion_state(self, leaders, followers):
    #     xn = self.current_state
    #     neighbors_repelled = []
    #     if self.data.depth_flag == 1:
    #         neighbors_repelled.append(self.neighbors_leaders[0])
        
    #     for i in range(0, len(self.neighbors_followers)):
    #         a = self.neighbors_followers[i].depth_flag 
    #         b = self.data.depth_flag
                 
    #         if a == b or a == b - 1:
    #             neighbors_repelled.append(self.neighbors_followers[i])

    #     min_id = np.inf
    #     for i in range(0, len(neighbors_repelled)):
    #         dist = np.linalg.norm(neighbors_repelled[i].state[0:2] -
    #                 self.current_state[0:2])
    #         if dist < min_id:
    #             min_id = dist
    #             repelled_identity = neighbors_repelled[i].identity
    #             repelled_depth_flag = neighbors_repelled[i].depth_flag

    #     for i in range(0, len(neighbors_repelled)):
    #         if repelled_identity == neighbors_repelled[i].identity:
    #             xo = neighbors_repelled[i].state
    #             break

    #     dist_coll_avoidance = np.linalg.norm(xo[0:2] - xn[0:2])

    #     if dist_coll_avoidance < r_r:
    #         self.data.prev_repelled_state = xo
    #     else:
    #         xo = self.data.prev_repelled_state

    #     return xo, repelled_identity, repelled_depth_flag

    # def allignment_state(self, leaders, followers):
    #     """This input alligns all the followers with leader"""
    #     xn = self.current_state
    #     if self.data.depth_flag == 1:
    #         xo = self.neighbors_leaders[0].state
    #     else:
    #         for i in range(0, len(self.neighbors_followers)):
    #             if self.neighbors_followers[i].identity ==\
    #                self.data.leader_identity:
    #                xo = self.neighbors_followers[i].state
                
    #     return u
