import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib import animation

v_p = 2.0
v_e = 1.0

dt = 0.01
tf = 30
no_iter = np.int(tf/dt)
no_iter_mark = no_iter

time = np.zeros([no_iter])


fig = plt.figure()
fig.set_size_inches(7, 6.5)

ax = plt.axes(xlim=(-5, 5), ylim=(-5, 5))
ax.grid()
patch_e = plt.Circle((1.4, 1), 0.1, fc='b')
patch_p1 = plt.Circle((0, 0), 0.1, fc='y')
patch_p2 = plt.Circle((5, 0), 0.1, fc='r')

def init():
    ax.add_patch(patch_e)
    ax.add_patch(patch_p1)
    ax.add_patch(patch_p2)
    return patch_e, patch_p1, patch_p2

def animate(i):
    rad_p = v_p*dt*i
    rad_e = v_e*dt*i
    patch_e.radius = rad_e
    patch_p1.radius = rad_p
    patch_p2.radius = rad_p
    return patch_e, patch_p1, patch_p2

anim = animation.FuncAnimation(fig, animate, init_func=init, frames=760, 
        interval=50, blit=True)

# anim.save('animation.mp4', fps=30, extra_args=['-vcodec', 'h264'])

plt.show()

