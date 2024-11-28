import numpy as np
import rk_forward as rk_f
import matplotlib.pyplot as plt
import system_define as sys


x0 = np.array([0, 0, 3.0, 3.0])


t0 = 0
tf = 5
h = 0.1
no_inputs = 2

output = 't'
[t, x, u] = rk_f.rk_for(sys.simple_mot, sys.input_simple, t0, tf, h,
                        no_inputs, x0, output)

if output == 't':
    # plt.gca().invert_xaxis()
    plt.figure(1)
    # set the grid on
    plt.grid('on')
    # set the basic properties
    plt.xlabel('Time(t)')
    plt.ylabel(r'Position of Particle ($\theta$)')
    plt.title('Likelihood of Reaching the Frontpage')
    # set the limits
    plt.xlim(0, 5)
    plt.ylim(-1, 6)
    # plot the graph
    # plt.plot(t[0, :], x[0, :])
    plt.plot(x[0, :], x[1, :])
    plt.plot(x[2, :], x[3, :])
    plt.show()
elif output == 's':
    print(x)
