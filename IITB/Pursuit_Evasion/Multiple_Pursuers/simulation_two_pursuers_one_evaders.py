import numpy as np 
import matplotlib.pyplot as plt
import tangfunc as tang
# import matplotlib.patches as patches
# from matplotlib import animation

vp = 2
z0p1 = [0, 0]
z0p2 = [5, 0]
ve = 1
z0e = [2.2, 1]

def pur_dyn(x, u):
    return np.array([vp*np.cos(u), vp*np.sin(u)])

def eva_dyn(x, u):
    return np.array([ve*np.cos(u), ve*np.sin(u)])

def line_side(x, y, m, c):
    return np.sign(y-m*x-c)


dt = 0.01
tf = 10
no_iter = int(tf/dt)
no_iter_mark = no_iter

states_p1 = np.zeros([no_iter, 2])
states_p2 = np.zeros([no_iter, 2])
states_e = np.zeros([no_iter, 2])
input_p1 = np.zeros([no_iter])
input_p2 = np.zeros([no_iter])
input_e = np.zeros([no_iter])
time = np.zeros([no_iter])

states_p1[0, :] = z0p1
states_p2[0, :] = z0p2
states_e[0, :] = z0e

for i in range(0, no_iter-1):
    print(i)
    x1 = states_p1[i,0]
    y1 = states_p1[i,1]
    x2 = states_p2[i,0]
    y2 = states_p2[i,1]
    xe = states_e[i,0]
    ye = states_e[i,1]

    # print(x1, y1, x2, y2, xe, ye)

    if np.abs(y2) - np.abs(y1) <= 0.1:
        m1 = np.pi/2
        # print('I am equal')
    else:
        m1 = -(x2-x1)/(y2-y1)
    c1 = ((y1+y2)-m1*(x1+x2))/2

    m2 = (ye-y1)/(xe-x1) 
    c2 = (y1*xe-ye*x1)/(xe-x1)

    # print(m1, c1, m2, c2)

    x_int1 = (c2-c1)/(m1-m2)
    y_int1 = (m1*c2-m2*c1)/(m1-m2)

    t_bar1 = np.sqrt((ye-y1)**2+(xe-x1)**2)/(vp-ve)
    t_til1 = np.sqrt((y_int1-ye)**2+(x_int1-xe)**2)/(ve)


    m2 = (ye-y2)/(xe-x2) 
    c2 = (y2*xe-ye*x2)/(xe-x2)

    # print(m1, c1, m2, c2)

    x_int2 = (c2-c1)/(m1-m2)
    y_int2 = (m1*c2-m2*c1)/(m1-m2)

    t_bar2 = np.sqrt((ye-y2)**2+(xe-x2)**2)/(vp-ve)
    t_til2 = np.sqrt((y_int2-ye)**2+(x_int2-xe)**2)/(ve)

    # print(line_side(xe, ye, m1, c1), "hi1")
    # print(line_side(x1, y1, m1, c1), 'hi2')

    if line_side(xe, ye, m1, c1) == line_side(x1, y1, m1, c1):
        side = 1
    else:
        side = 2

    # print("I am side", side)




    if side == 1 and (t_bar1 <= t_til1):
        # print('hi')
        up1_t = np.arctan2(ye-y1, xe-x1)
        up2_t = np.arctan2(y2-y2, xe-x2)
        # ue_t = np.arctan2(-(y1-ye), -(x1-xe))
        ue_t = np.arctan2(x1-ye, y1-xe)
    elif side == 2 and (t_bar2 <= t_til2):
        # print('hi')
        up1_t = np.arctan2(y1-y1, xe-x1)
        up2_t = np.arctan2(ye-y2, xe-x2)
        # ue_t = np.arctan2(-(y2-ye), -(x2-xe))
        ue_t = np.arctan2(x1-ye, y1-xe)
    else:
        alpha = ((-8*ye*x1**2*vp**2 + 8*xe*x1*y1*vp**2 - 4*x1**2*y1*vp**2 - 4*y1**3*vp**2 + 16*ye*x1*x2*vp**2 - 8*xe*y1*x2*vp**2 - 8*ye*x2**2*vp**2 + 4*y1*x2**2*vp**2 - 8*xe*x1*y2*vp**2 + 4*x1**2*y2*vp**2 + 4*y1**2*y2*vp**2 + 8*xe*x2*y2*vp**2 - 4*x2**2*y2*vp**2 + 4*y1*y2**2*vp**2 - 4*y2**3*vp**2 + 4*x1**2*y1*ve**2 + 4*y1**3*ve**2 - 8*x1*y1*x2*ve**2 + 4*y1*x2**2*ve**2 + 4*x1**2*y2*ve**2 - 4*y1**2*y2*ve**2 - 8*x1*x2*y2*ve**2 + 4*x2**2*y2*ve**2 - 4*y1*y2**2*ve**2 + 4*y2**3*ve**2)/(4*x1**2*vp**2 + 4*y1**2*vp**2 - 8*x1*x2*vp**2 + 4*x2**2*vp**2 - 8*y1*y2*vp**2 + 4*y2**2*vp**2 - 4*x1**2*ve**2 - 4*y1**2*ve**2 + 8*x1*x2*ve**2 - 4*x2**2*ve**2 + 8*y1*y2*ve**2 - 4*y2**2*ve**2))

        beta = (4*xe**2*x1**2*vp**2 + 4*ye**2*x1**2*vp**2 - 4*xe*x1**3*vp**2 + x1**4*vp**2 - 4*xe*x1*y1**2*vp**2 + 2*x1**2*y1**2*vp**2 + y1**4*vp**2 - 8*xe**2*x1*x2*vp**2 - 8*ye**2*x1*x2*vp**2 + 4*xe*x1**2*x2*vp**2 + 4*xe*y1**2*x2*vp**2 + 4*xe**2*x2**2*vp**2 + 4*ye**2*x2**2*vp**2 + 4*xe*x1*x2**2*vp**2 - 2*x1**2*x2**2*vp**2 - 2*y1**2*x2**2*vp**2 - 4*xe*x2**3*vp**2 + x2**4*vp**2 + 4*xe*x1*y2**2*vp**2 - 2*x1**2*y2**2*vp**2 - 2*y1**2*y2**2*vp**2 - 4*xe*x2*y2**2*vp**2 + 2*x2**2*y2**2*vp**2 + y2**4*vp**2 - x1**4*ve**2 - 2*x1**2*y1**2*ve**2 - y1**4*ve**2 + 4*x1**3*x2*ve**2 + 4*x1*y1**2*x2*ve**2 - 6*x1**2*x2**2*ve**2 - 2*y1**2*x2**2*ve**2 + 4*x1*x2**3*ve**2 - x2**4*ve**2 - 2*x1**2*y2**2*ve**2 + 2*y1**2*y2**2*ve**2 + 4*x1*x2*y2**2*ve**2 - 2*x2**2*y2**2*ve**2 - y2**4*ve**2)/(4*x1**2*vp**2 + 4*y1**2*vp**2 - 8*x1*x2*vp**2 + 4*x2**2*vp**2 - 8*y1*y2*vp**2 + 4*y2**2*vp**2 - 4*x1**2*ve**2 - 4*y1**2*ve**2 + 8*x1*x2*ve**2 - 4*x2**2*ve**2 + 8*y1*y2*ve**2 - 4*y2**2*ve**2) 

        yc = (-alpha + np.sqrt(alpha**2-4*beta))/2

        xc = -(((2*y1 - 2*y2)/(2*x1 - 2*x2))*yc + (-x1**2 - y1**2 + x2**2 + y2**2)/(2*x1 - 2*x2))

        # print(xc, yc)

        up1_t = np.arctan2(yc-y1, xc-x1)
        up2_t = np.arctan2(yc-y2, xc-x2)
        # ue_t = np.arctan2(yc-ye, xc-xe)
        ue_t = np.arctan2(x1-ye, x2-xe)



    input_p1[i] = up1_t
    input_p2[i] = up2_t
    input_e[i] = ue_t
    states_p1[i+1,:] = states_p1[i,:] + pur_dyn(states_p1[i,:], up1_t)*dt
    states_p2[i+1,:] = states_p2[i,:] + pur_dyn(states_p2[i,:], up2_t)*dt
    states_e[i+1,:] = states_e[i,:] + eva_dyn(states_e[i,:], ue_t)*dt
    time[i+1] = time[i] + dt
    d1 = tang.calc_dist(states_e[i,0], states_e[i, 1], states_p1[i, 0], states_p1[i, 1])
    d2 = tang.calc_dist(states_e[i,0], states_e[i, 1], states_p2[i, 0], states_p2[i, 1])
    if d1 < 0.1 or d2 < 0.1:
        no_iter_mark = i - 2
        print(time[i])
        break 

#  Figure 1 only plots the trajectories
plt.figure(1)
# plt.plot(states_e[0:no_iter_mark,0], states_e[0:no_iter_mark,1])
# plt.plot(states_p1[0:no_iter_mark,0], states_p1[0:no_iter_mark,1])
# plt.plot(states_p2[0:no_iter_mark,0], states_p2[0:no_iter_mark,1])
plt.plot(states_e[:no_iter_mark,0], states_e[:no_iter_mark,1])
plt.plot(states_p1[:no_iter_mark,0], states_p1[:no_iter_mark,1])
plt.plot(states_p2[:no_iter_mark,0], states_p2[:no_iter_mark,1])
plt.axis('scaled')
plt.grid()
plt.show()

# x_lim = plt.xlim()
# y_lim = plt.ylim()

# axes_limits = [x_lim[0]-1, x_lim[1]+1, y_lim[0]-1, y_lim[1]+1]


# # The code for animation starts here

# x1 = states_p[0:no_iter_mark, 0]
# y1 = states_p[0:no_iter_mark, 1]
# theta1 = states_p[0:no_iter_mark, 2]
# x2 = states_e[0:no_iter_mark, 0]
# y2 = states_e[0:no_iter_mark, 1]
# theta2 = states_e[0:no_iter_mark, 2]


# def anime(x1, y1, theta1, x2, y2, theta2):
#     def plot_arrow(x, y, theta):
#         return patches.FancyArrow(x, y, 0.5*np.cos(theta), 0.5*np.sin(theta),
#                 width = 0.3, head_width =0.3, head_length=0.1)


#     fig = plt.figure()
#     fig.set_size_inches(7, 6.5)

#     ax = plt.axes(xlim=(-2.5, 7.5), ylim=(-2.5, 7.5))
#     ax.grid()
#     line_p, = ax.plot([],[], lw=2)
#     line_e, = ax.plot([],[], lw=2)
#     patch_p = plot_arrow(x1[0], y1[0], theta1[0])
#     patch_e = plot_arrow(x1[0], y1[0], theta1[0])

#     def init():
#         line_p.set_data([], [])
#         line_e.set_data([], [])
#         patch_p1 = ax.add_patch(patch_p)
#         patch_e1 = ax.add_patch(patch_e)
#         return patch_p1, patch_e1, line_p, line_e

#     def animate(i):
#         line_p.set_data(x1[:i], y1[:i])
#         line_e.set_data(x2[:i], y2[:i])
#         patch_p = ax.add_patch(plot_arrow(x1[i], y1[i], theta1[i]))
#         patch_e = ax.add_patch(plot_arrow(x2[i], y2[i], theta2[i]))
#         return patch_p, patch_e, line_p, line_e

#     anim = animation.FuncAnimation(fig, animate, init_func=init, frames=360, 
#                                    interval=30, blit=True)

#     # anim.save('animation.mp4', fps=30, extra_args=['-vcodec', 'h264'])

#     plt.show()

# anime(x1, y1, theta1, x2, y2, theta2)
