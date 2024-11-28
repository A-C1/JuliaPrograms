from simulink import Dynamics
import numpy as np
import matplotlib.pyplot as plt
import tangfunc_const as tang


r = 15  # Communication Radius
r_r = 6  # repulsion radius
r_a = 8  # radius of allignment

vf = 2.2  # Velocity of followers
uf = 2.2  # Turning input of followers
vl = 2  # Velocity of leader
ul = 2  # Turning input of leader


class SimpleFollower(Dynamics):

    """This class creates a follower and defines number of
       functions which are necessary"""
    followers_count = 0   # Counts the number of followers created

    def __init__(self, init_state):
        """TODO: Initializes the values of initial state and all the flags """
        Dynamics.__init__(self, init_state)
        self.depth_flag = np.nan  # Value of depth flag set to infinity
        # This is the identit assigned to each follower
        self.identity = SimpleFollower.followers_count
        # Initially false. Set to true if the follower converges to the leader
        self.converge_flag = False
        # Increaments the follower count whenever a follower is created
        SimpleFollower.followers_count += 1
        self.veh_id = 0  # id of the vehicle
        self.neighbors = []  # Neighbors
        self.neighbors_states = []  # Neighbors

    def observed_identifier(self, leaders, followers):
        """TODO: Set the leader and the depth flag"""
        # Calculate the distance between self and the leader
        dist_lead = np.linalg.norm(leaders[0].current_state[0:2] -
                                   self.current_state[0:2])
        if dist_lead < r:  # If leader is within communication range
            self.depth_flag = 1
            self.veh_id = -1
            self.least_dist = dist_lead

        else:  # If leader is not within communication range
            prev_flag = np.nan  # Variable to store flag
            # Sift through all the followers
            for i in range(0, len(followers)):
                dist = np.linalg.norm(self.current_state[0:2] -
                                      followers[i].current_state[0:2])
                # This is very complicated if statement I must comment it
                # thoghrouly. Though it is self explanatory some of the things
                # are inherent to the algorithm while others are inherent to
                # the code. 1. dist < r checks if the particular agent being
                # tested is within the communication range. 2.followers[i].
                # depth_flag != np.nan ensures that the agent being checked has
                # already set its flag 3.  self.depth_flag != 1: leader is not
                # the one being followed 4. followers[i].depth_flag <=
                # prev_flag: The follower is selected only if it is at a lower
                # depth than the current selected follower
                if dist < r and \
                   followers[i].depth_flag != np.nan and self.depth_flag != 1 \
                   and self.identity != i and followers[i].depth_flag <= \
                   prev_flag:
                    self.veh_id = i
                    self.depth_flag = followers[i].depth_flag + 1
                    prev_flag = followers[i].depth_flag

    def input_sys(self, leaders, followers):
        xn = self.current_state

        # for i in range(0, self.followers_count):
        # 	if

        if self.veh_id == -1:
            xo = leaders[0].current_state
            ve = vl
            ue = ul
        else:
            xo = followers[self.veh_id].current_state
            if followers[self.veh_id].converge_flag:
                ve = vl
                ue = ul
            else:
                ve = vf
                ue = uf

        vp = vf
        up = uf
        local_lead_dist = np.linalg.norm(xo[0:2]
                                         - self.current_state[0:2])
        if local_lead_dist <= 0:
            self.converge_flag = True
            vp = vl
            up = ul

        if local_lead_dist > r_r:
            [up_t, ue_t, matrix] = tang.calc_input(vp, up, xn,
                                                   ve, ue, xo)
        else:
            [ue_t, up_t, matrix] = tang.calc_input(ve, ue, xo,
                                                   vp, up, xn)

        # [up_t, ue_t] = tang.calc_input_los(vf, uf, xn,
            # ve, ue, xo)

        u = up_t

        return u

    def dynamics(self, x, t, u):
        x1 = vf * np.cos(x[2])
        y1 = vf * np.sin(x[2])
        theta1 = vf * u
        f_x = np.array([x1, y1, theta1])
        return f_x

    def select_leader(self):
        pass


class SimpleLeader(Dynamics):

    """Docstring for Simple. """

    def __init__(self, init_state):
        """TODO: to be defined1. """
        Dynamics.__init__(self, init_state)
        self.depth_flag = 0
        self.flag = 1

    def input_sys(self, leaders, followers):
        xn = self.current_state
        xo = np.array([100, 500, np.pi / 2])
        [up_t, ue_t, matrix] = tang.calc_input(vl, ul, xn,
                                               0.3, 0.3, xo)
        u = up_t
        return u

    def dynamics(self, x, t, u):
        x1 = vl * np.cos(x[2])
        y1 = vl * np.sin(x[2])
        theta1 = vl * u
        f_x = np.array([x1, y1, theta1])
        return f_x


Dynamics.initial_time = 0
Dynamics.final_time = 7
Dynamics.step_size = 0.001


# Create agents with initial Conditions
followers = []
followers.append(SimpleFollower([3., 3, np.pi / 2]))
followers.append(SimpleFollower([-4., 3, np.pi / 2]))
# followers.append(SimpleFollower([7., -7, np.pi/2]))
# followers.append(SimpleFollower([7, -15, np.pi/2]))

leaders = []
a0 = SimpleLeader([0., 8, np.pi / 2])
leaders.append(a0)

# Some initial Settings
no_iter = a0.no_iter
t = np.zeros(no_iter)
t0 = 0

for l in range(0, SimpleFollower.followers_count):
    for m in range(0, SimpleFollower.followers_count):
        followers[m].observed_identifier(leaders, followers)

# Run the Simulation
for i in range(0, no_iter):
    # for l in range(0, SimpleFollower.followers_count):
    #     for m in range(0, SimpleFollower.followers_count):
    #         followers[m].observed_identifier(leaders, followers)
    # Updating the states being observed
    leaders[0].states[:, i] = leaders[0].update_state(leaders=leaders,
                                                      followers=followers)
    for j in range(0, SimpleFollower.followers_count):
        followers[j].states[:, i] \
            = followers[j].update_state(leaders=leaders, followers=followers)
    converge = True
    for j in range(0, SimpleFollower.followers_count):
        converge = converge and followers[j].converge_flag

    if converge:
        break

    t[i] = t0
    t0 = t0 + Dynamics.step_size
    new_iter = i


plt.figure(1)
for j in range(0, SimpleFollower.followers_count):
    plt.plot(followers[j].states[0, 0:new_iter],
             followers[j].states[1, 0:new_iter], linewidth=2.0,
             label='a' + str(j))
plt.plot(leaders[0].states[0, 0:new_iter], leaders[0].states[1, 0:new_iter],
         linewidth=2.0, label='leader')
plt.grid()
plt.xlabel('x-position')
plt.ylabel('y-position')
plt.title('x-y graph for all agents')
plt.legend(loc='upper left', frameon=False)
plt.axis('equal')
# plt.savefig('/home/aditya/Dropbox/Multiple_Leaders_2018/Multiple_Lyx/xy_plot_dynamic.png')
plt.show()
print(t0)
