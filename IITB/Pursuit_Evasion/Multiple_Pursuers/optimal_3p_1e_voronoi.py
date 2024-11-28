import numpy as np
import matplotlib.pyplot as plt
import tangfunc_const as tang
# import matplotlib.patches as patches
from matplotlib import animation

vp = 2
z0p1 = [0, 0]
z0p2 = [5, 0]
z0p3 = [2.5, 5]
ve = 2
z0e = [2.5, 1]

def pur_dyn(x, u):
    return np.array([vp*np.cos(u), vp*np.sin(u)])

def eva_dyn(x, u):
    return np.array([ve*np.cos(u), ve*np.sin(u)])

def parallel_nav(xp, yp, xe, ye, xe_prev, ye_prev):
    vec_ep = np.array([xp-xe, yp-ye])    # Vector from evader to pursuer
    vec_pe = np.array([xe-xp, yp-ye])

    # ve_p = np.array([yp-ye, -xp+xe])    # perpendicular to Vector from evader to pursuer
    ve_p = vec_ep/np.linalg.norm(vec_ep)
    vp_e = vec_pe/np.linalg.norm(vec_pe)

    vec_e = np.array([xe-xe_prev, ye-ye_prev])
    angle_e = tang.acangle(vec_ep, vec_e) 
    Q = np.identity(2) - 2*ve_p.reshape(2, 1 ) @ ve_p.reshape(1, 2)
    # print("vp_e = ", vp_e)
    # print("Q = ", Q)
    # print("Dot_product = ",vp_e.reshape(2, 1) @ vp_e.T.reshape(1, 2))

    if angle_e <= 90:
        vec_p =  Q @ vec_e
    elif 90 < angle_e <=270:
        vec_p = vec_e
    elif 270 < angle_e  <=360:
        vec_p = Q @ vec_e

    # print("hello")
    # print("p_vec = ",vec_p)
    # print("e_vec = ",vec_e)
    # print("ep_vec= ",vec_ep)
    # print("perp_vec= ",ve_p)
    theta = tang.acangle(np.array([0, 0]), vec_p)
    # print("p_ang=",theta)
    return theta*np.pi/180

dt = 0.001
tf = 200
no_iter = int(tf/dt)
no_it = no_iter
# no_iter = 2
no_iter_mark = no_iter

states_p1 = np.zeros([no_iter, 2])
states_p2 = np.zeros([no_iter, 2])
states_p3 = np.zeros([no_iter, 2])
states_e = np.zeros([no_iter, 2])
input_p1 = np.zeros([no_iter])
input_p2 = np.zeros([no_iter])
input_p3 = np.zeros([no_iter])
input_e = np.zeros([no_iter])
time = np.zeros([no_iter])

states_p1[0, :] = z0p1
states_p2[0, :] = z0p2
states_p3[0, :] = z0p3
states_e[0, :] = z0e

for i in range(0, no_iter - 1):
    x1 = states_p1[i, 0]
    y1 = states_p1[i, 1]
    x2 = states_p2[i, 0]
    y2 = states_p2[i, 1]
    x3 = states_p3[i, 0]
    y3 = states_p3[i, 1]
    xe = states_e[i, 0]
    ye = states_e[i, 1]

    dist1 = np.linalg.norm(states_p1[i, :] - states_e[i, :])
    dist2 = np.linalg.norm(states_p2[i, :] - states_e[i, :])
    dist3 = np.linalg.norm(states_p3[i, :] - states_e[i, :])

    tar_rad = 0.1

    if dist1 < tar_rad or dist2 < tar_rad or dist3 < tar_rad:
        print("Gotcha!!")
        print("Time of Capture = ",i*dt)
        no_it = i
        break

    if i == no_iter-2:
        print("not_gotcha")

    # Pursuer 1 and Evader
    m1 = -(x1-xe)/(y1-ye)
    c1 = (y1+ye)/2 + (x1+xe)*(x1-xe)/(2*(y1-ye))

    # Pursuer 2 and Evader
    m2 = -(x2-xe)/(y2-ye)
    c2 = (y2+ye)/2 + (x2+xe)*(x2-xe)/(2*(y2-ye))

    # Pursuer 3 and Evader
    m3 = -(x3-xe)/(y3-ye)
    c3 = (y3+ye)/2 + (x3+xe)*(x3-xe)/(2*(y3-ye))

    # Between Pursuer 1 and 2
    xc_12 = -(c1-c2)/(m1-m2)
    yc_12 = (m1*c2-m2*c1)/(m1-m2)


    # Between Pursuer 1 and 3
    xc_13 = -(c1-c3)/(m1-m3)
    yc_13 = (m1*c3-m3*c1)/(m1-m3)

    # Between Pursuer 2 and 3
    xc_23 = -(c3-c2)/(m3-m2)
    yc_23 = (m3*c2-m2*c3)/(m3-m2)

    # The centroid
    x_cen = (x1 + x2 + x3)/3
    y_cen = (y1 + y2 + y3)/3

    v12 = np.array([xc_12, yc_12])
    v13 = np.array([xc_13, yc_13])
    v23 = np.array([xc_23, yc_23])
    v4 = np.array([x_cen, y_cen])

    dist1_c = np.linalg.norm(v12-states_e[i,:])
    dist2_c = np.linalg.norm(v13-states_e[i,:])
    dist3_c = np.linalg.norm(v23-states_e[i,:])
    dist4_c = np.linalg.norm(v4-states_e[i,:])

    dist = np.array([dist1_c, dist2_c, dist3_c, dist4_c])
    points = [v12, v13, v23, v4]

    j = np.argmax(dist)
    
    xc = points[j][0]
    yc = points[j][1]

    # xc_e = xc
    # yc_e = yc
    # xc_e = 34*np.cos(i*dt)
    # yc_e = 40*np.sin(i*dt)
    xc_e = 2.5
    yc_e = -130

    # if i%2 == 0:
    #     ue_t = 0
    # elif i%3 == 0:
    #     ue_t = np.pi/2
    # elif i%4 == 0:
    #     ue_t = np.pi
    # else:
    #     ue_t = 3*np.pi/2

    ue_t = np.arctan2(yc_e-ye, xc_e-xe)
    input_e[i] = ue_t
    states_e[i+1,:] = states_e[i,:] + eva_dyn(states_e[i,:], ue_t)*dt
    xe_prev = xe
    ye_prev = ye
    xe = states_e[i+1, 0]
    ye = states_e[i+1, 1]


    up1_t = parallel_nav(x1, y1, xe, ye, xe_prev, ye_prev)
    up2_t = parallel_nav(x2, y2, xe, ye, xe_prev, ye_prev)
    up3_t = parallel_nav(x3, y3, xe, ye, xe_prev, ye_prev)


    up1_t = np.arctan2(yc-y1, xc-x1)
    up2_t = np.arctan2(yc-y2, xc-x2)
    up3_t = np.arctan2(yc-y3, xc-x3)


    input_p1[i] = up1_t
    input_p2[i] = up2_t
    input_p3[i] = up3_t

    states_p1[i+1,:] = states_p1[i,:] + pur_dyn(states_p1[i,:], up1_t)*dt
    states_p2[i+1,:] = states_p2[i,:] + pur_dyn(states_p2[i,:], up2_t)*dt
    states_p3[i+1,:] = states_p3[i,:] + pur_dyn(states_p3[i,:], up3_t)*dt

    time[i+1] = time[i] + dt






# Animation
def anime(x1, y1, x2, y2, x3, y3, xe, ye):
    
    fig = plt.figure()
    fig.set_size_inches(7, 6.5)
    
    ax = plt.axes(xlim=(-1, 8), ylim=(-3, 6))
    ax.grid()
    line_p1, = ax.plot([],[], lw=2)
    line_p2, = ax.plot([],[], lw=2)
    line_p3, = ax.plot([],[], lw=2)
    line_e, = ax.plot([],[], lw=2)
    agents, = ax.plot([], [], 'o', lw=6)
    
    def init():
        line_p1.set_data([], [])
        line_p2.set_data([], [])
        line_p3.set_data([], [])
        line_e.set_data([], [])
        agents.set_data([], [])
        return line_p1, line_p2, line_p3, line_e, agents
    
    def animate(i):
        line_p1.set_data(x1[:i], y1[:i])
        line_p2.set_data(x2[:i], y2[:i])
        line_p3.set_data(x3[:i], y3[:i])
        line_e.set_data(xe[:i], ye[:i])
        a = np.array([x1[i-1:i], x2[i-1:i], x3[i-1:i], xe[i-1:i]])
        b = np.array([y1[i-1:i], y2[i-1:i], y3[i-1:i], ye[i-1:i]])
        agents.set_data(a, b)
        return line_p1, line_p2, line_p3, line_e, agents
    
    anim = animation.FuncAnimation(fig, animate, init_func=init, frames=3500, 
                                   interval=4, blit=True)
    
    # anim.save('animation.mp4', fps=30, extra_args=['-vcodec', 'h264'])
    # anim.save('line.gif', dpi=80, writer='imagemagick') 
    plt.show()

anime(states_p1[:no_it, 0], states_p1[:no_it, 1],
      states_p2[:no_it, 0], states_p2[:no_it, 1],
      states_p3[:no_it, 0], states_p3[:no_it, 1],
      states_e[:no_it, 0], states_e[:no_it, 1])
#  Figure 1 only plots the trajectories
plt.figure(1)
# plt.plot(states_e[0:no_iter_mark,0], states_e[0:no_iter_mark,1])
# plt.plot(states_p1[0:no_iter_mark,0], states_p1[0:no_iter_mark,1])
# plt.plot(states_p2[0:no_iter_mark,0], states_p2[0:no_iter_mark,1])
plt.plot(states_e[:no_it,0], states_e[:no_it,1])
plt.plot(states_p1[:no_it,0], states_p1[:no_it,1])
plt.plot(states_p2[:no_it,0], states_p2[:no_it,1])
plt.plot(states_p3[:no_it,0], states_p3[:no_it,1])
plt.axis('scaled')
plt.grid()
plt.show()
