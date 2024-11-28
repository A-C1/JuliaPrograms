from simulink import Dynamics
from leader_class import SimpleLeader
from follower_class_no_collision_avoidance import SimpleFollower
import numpy as np
import matplotlib.pyplot as plt


# Simulation parameters
class sim_param:
    step_size = 0.05
    initial_time = 0.0
    final_time = 55.0

class sys_param:
    vf_max = 3  # Velocity of followers
    uf_max = 2  # Turning input of followers
    vl_max = 1  # Velocity of leader
    ul_max = 1  # Turning input of leader

    r = 20  # Communication Radius
    r_au = 3  # radius of allignment upper bound
    dt_allign = 4  # Time for holding allignment


no_iter = np.int((sim_param.final_time-sim_param.initial_time)
                 /sim_param.step_size)
t = np.zeros(no_iter)

SimpleFollower.sim_param = sim_param
SimpleFollower.sys_param = sys_param
SimpleLeader.sim_param = sim_param


# # Create follower agents with initial conditions
followers = []
# followers.append(SimpleFollower([1., 0, -np.pi/2]))
# followers.append(SimpleFollower([1., 1, np.pi/2]))
# followers.append(SimpleFollower([0., 1, np.pi/4]))
# followers.append(SimpleFollower([-1., 2, 3*np.pi/6]))
# followers.append(SimpleFollower([2., 0.3, 4*np.pi/3]))
# followers.append(SimpleFollower([1.2, 1.8, np.pi/5]))
# followers.append(SimpleFollower([2, 1.4, 0]))
# followers.append(SimpleFollower([0.3, 1.8, 0]))
# followers.append(SimpleFollower([1.6, 2.6, 0]))
# followers.append(SimpleFollower([3., 1., 0]))
# followers.append(SimpleFollower([.6, 2.7, 0]))
# followers.append(SimpleFollower([0.3, 3.7, 0]))
# followers.append(SimpleFollower([-0.7, 3., 0]))
# followers.append(SimpleFollower([-1, 4., 0]))
# followers.append(SimpleFollower([-2.2, 3.3, 0]))
# followers.append(SimpleFollower([.2, 4.6, 0]))
# followers.append(SimpleFollower([.85, 5, 0]))
# followers.append(SimpleFollower([-2.2, 4.21, 0]))
# followers.append(SimpleFollower([1.6, 4, 0]))
# followers.append(SimpleFollower([-2.3, 2.1, 0]))

# Nice Initial conditions for single leader and Multiple dubins Vehicles
followers.append(SimpleFollower([3., 3, np.pi / 2]))
followers.append(SimpleFollower([-4., 3, np.pi / 2+np.pi/4]))
followers.append(SimpleFollower([7., -7, np.pi/2 - np.pi/3]))
followers.append(SimpleFollower([7, -15, np.pi/2 + np.pi/7]))
followers.append(SimpleFollower([-7, -21, np.pi/2 + np.pi/7]))
followers.append(SimpleFollower([-7, -28, np.pi/2 + np.pi/7]))
followers.append(SimpleFollower([7, -28, np.pi/2 + np.pi/7]))
followers.append(SimpleFollower([7, -35, np.pi/2 + np.pi/7]))
followers.append(SimpleFollower([-7, -35, np.pi/2 + np.pi/7]))

# # Create leaders with initial conditions
leaders = []
# leaders.append(SimpleLeader([0., 0, 0]))
# leaders.append(SimpleLeader([3., 2.5, np.pi/2]))
# leaders.append(SimpleLeader([-1., 5, np.pi/2+np.pi/4]))

# Nice Initial conditions for single leader and Multiple dubins Vehicles
leaders.append(SimpleLeader([0., 8, np.pi / 2]))


# Follow the leader
# This for loop selects local leader for each follower agent.
# This effectively selects a directed spanning tree from the
# communication graph.
for l in range(0, SimpleFollower.followers_count):
    for m in range(0, SimpleFollower.followers_count):
        followers[m].select_leader(leaders, followers)

# This loop prints all the data about selected tree structure.
for l in range(0, SimpleFollower.followers_count):
    print(followers[l].data.identity,"  ",followers[l].data.depth_flag,"  ",
            followers[l].data.leader_identity, "  ",
            [followers[l].neighbors_followers[i].identity for i in
                range(0,len(followers[l].neighbors_followers))], "  ",
            [followers[l].neighbors_leaders[i].identity for i in
                range(0,len(followers[l].neighbors_leaders))])


# Run the Simulation
t[0] = sim_param.initial_time
for i in range(0, no_iter-1):
    # This loop updates the local leader of each follower agent.
    # Effectively it is used if one wants to update the spanning tree
    # at each instant.
    # for l in range(0, SimpleFollower.followers_count):
    #     for m in range(0, SimpleFollower.followers_count):
    #         followers[m].select_leader(leaders, followers)

    # Updating the states being observed
    leaders[0].states[:, i] = leaders[0].update_state(leaders=leaders,
                                                      followers=followers)
    leaders[0].data.state = leaders[0].current_state
    for j in range(0, SimpleFollower.followers_count):
        followers[j].states[:, i] \
            = followers[j].update_state(leaders=leaders, followers=followers)
        followers[j].data.state = followers[j].current_state


    # Checking convergence. I have forgotten what this statement does.
    # converge = True
    # for j in range(0, SimpleFollower.followers_count):
    #     converge = converge and followers[j].converge_flag

    # if converge:
    #     break

    t[i+1] = t[i] + sim_param.step_size
    new_iter = i

# This statement is for checking the correctness of code.
for i in range(0, len(followers)):
    print(followers[i].data.state[2])

# The first plot depicts the convergence of angles
plt.figure(1)
for j in range(0, SimpleFollower.followers_count):
    plt.plot(t[0:new_iter], followers[j].states[2, 0:new_iter], linewidth=2.0,
             label='a' + str(j))
plt.plot(t[0:new_iter], leaders[0].states[2, 0:new_iter],
    linewidth=2.0, label='leader')
plt.grid()
plt.xlabel('x-position')
plt.ylabel('y-position')
plt.title('x-y graph for all agents')
plt.legend(loc='upper left', frameon=False)
plt.axis('equal')
# plt.savefig('/home/aditya/Dropbox/Multiple_Leaders_2018/Multiple_Lyx/xy_plot_dynamic.png')

#The second plot depicts the motion of agents in x-y plane.
plt.figure(2)
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


# Printing relevent data
for l in range(0, SimpleFollower.followers_count):
    print(followers[l].data.identity,"  ",followers[l].data.depth_flag,"  ",
            followers[l].data.leader_identity, "  ",
            [followers[l].neighbors_followers[i].identity for i in
                range(0,len(followers[l].neighbors_followers))], "  ",
            [followers[l].neighbors_leaders[i].identity for i in
                range(0,len(followers[l].neighbors_leaders))])
