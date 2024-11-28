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

def lateral_pursuit(xp, yp, xe, ye, xe_prev, ye_prev):
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

    # vec_p = vec_p / np.linalg.norm(vec_p) + vp_e
    

    # print("hello")
    # print("p_vec = ",vec_p)
    # print("e_vec = ",vec_e)
    # print("ep_vec= ",vec_ep)
    # print("perp_vec= ",ve_p)
    theta = tang.acangle(np.array([0, 0]), vec_p)
    # print("p_ang=",theta)
    return theta*np.pi/180

dt = 0.001
tf = 30
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

for i in range(0, no_iter-1):
    x1 = states_p1[i,0]
    y1 = states_p1[i,1]
    x2 = states_p2[i,0]
    y2 = states_p2[i,1]
    x3 = states_p3[i,0]
    y3 = states_p3[i,1]
    xe = states_e[i,0]
    ye = states_e[i,1]

    dist1 = np.linalg.norm(states_p1[i,:]-states_e[i,:])
    dist2 = np.linalg.norm(states_p2[i,:]-states_e[i,:])
    dist3 = np.linalg.norm(states_p3[i,:]-states_e[i,:])

    tar_rad = 0.1

    if dist1 < tar_rad or dist2 < tar_rad or dist3 < tar_rad:
        print("Gotcha!!")
        print("Time of Capture = ",i*dt)
        no_it = i
        break

    # Between Pursuer 1 and 2
    xc_12 = -(ye*x1**2 - xe**2*y1 - ye**2*y1 + ye*y1**2 - ye*x2**2 + y1*x2**2 + xe**2*y2 + ye**2*y2 - x1**2*y2 - y1**2*y2 -
           ye*y2**2 + y1*y2**2)/(-2*ye*x1 + 2*xe*y1 + 2*ye*x2 - 2*y1*x2 - 2*xe*y2 + 2*x1*y2)

    yc_12 = -(xe**2*x1 + ye**2*x1 - xe*x1**2 - xe*y1**2 - xe**2*x2 - ye**2*x2 + x1**2*x2 + y1**2*x2 + xe*x2**2 - x1*x2**2 +
           xe*y2**2 - x1*y2**2)/(-2*ye*x1 + 2*xe*y1 + 2*ye*x2 - 2*y1*x2 - 2*xe*y2 + 2*x1*y2)

    # Between Pursuer 1 and 3
    xc_13 = -(ye*x1**2 - xe**2*y1 - ye**2*y1 + ye*y1**2 - ye*x3**2 + y1*x3**2 + xe**2*y3 + ye**2*y3 - x1**2*y3 - y1**2*y3 -
           ye*y3**2 + y1*y3**2)/(-2*ye*x1 + 2*xe*y1 + 2*ye*x3 - 2*y1*x3 - 2*xe*y3 + 2*x1*y3)

    yc_13 = -(xe**2*x1 + ye**2*x1 - xe*x1**2 - xe*y1**2 - xe**2*x3 - ye**2*x3 + x1**2*x3 + y1**2*x3 + xe*x3**2 - x1*x3**2 +
           xe*y3**2 - x1*y3**2)/(-2*ye*x1 + 2*xe*y1 + 2*ye*x3 - 2*y1*x3 - 2*xe*y3 + 2*x1*y3)

    # Between Pursuer 1 and 3
    xc_23 = -(ye*x2**2 - xe**2*y2 - ye**2*y2 + ye*y2**2 - ye*x3**2 + y2*x3**2 + xe**2*y3 + ye**2*y3 - x2**2*y3 - y2**2*y3 -
           ye*y3**2 + y2*y3**2)/(-2*ye*x2 + 2*xe*y2 + 2*ye*x3 - 2*y2*x3 - 2*xe*y3 + 2*x2*y3)

    yc_23 = -(xe**2*x2 + ye**2*x2 - xe*x2**2 - xe*y2**2 - xe**2*x3 - ye**2*x3 + x2**2*x3 + y2**2*x3 + xe*x3**2 - x2*x3**2 +
           xe*y3**2 - x2*y3**2)/(-2*ye*x2 + 2*xe*y2 + 2*ye*x3 - 2*y2*x3 - 2*xe*y3 + 2*x2*y3)

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
    # xc = xc_12
    # yc = yc_12

    ue_t = np.arctan2(yc-ye, xc-xe)
    input_e[i] = ue_t
    states_e[i+1,:] = states_e[i,:] + eva_dyn(states_e[i,:], ue_t)*dt
    xe_prev = xe
    ye_prev = ye
    xe = states_e[i+1, 0]
    ye = states_e[i+1, 1]


    up1_t = lateral_pursuit(x1, y1, xe, ye, xe_prev, ye_prev)
    up2_t = lateral_pursuit(x2, y2, xe, ye, xe_prev, ye_prev)
    up3_t = lateral_pursuit(x3, y3, xe, ye, xe_prev, ye_prev)

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
    
    ax = plt.axes(xlim=(-5, 5), ylim=(-5, 5))
    ax.grid()
    line_p1, = ax.plot([],[], lw=2)
    line_p2, = ax.plot([],[], lw=2)
    line_p3, = ax.plot([],[], lw=2)
    line_e, = ax.plot([],[], lw=2)
    
    def init():
        line_p1.set_data([], [])
        line_p2.set_data([], [])
        line_p3.set_data([], [])
        line_e.set_data([], [])
        return line_p1, line_p2, line_p3, line_e
    
    def animate(i):
        line_p1.set_data(x1[:i], y1[:i])
        line_p2.set_data(x2[:i], y2[:i])
        line_p3.set_data(x3[:i], y3[:i])
        line_e.set_data(xe[:i], ye[:i])
        return line_p1, line_p2, line_p3, line_e
    
    anim = animation.FuncAnimation(fig, animate, init_func=init, frames=200, 
                                   interval=40, blit=True)
    
    # anim.save('animation.mp4', fps=30, extra_args=['-vcodec', 'h264'])
    
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
