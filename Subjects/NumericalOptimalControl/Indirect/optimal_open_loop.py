import numpy as np
import rk_forward as rk_f
import rk_backward as rk_b
import math as mt
import matplotlib.pyplot as plt
import system_define as sys
import optimal_define as od
import dyn_sys_config as ds


x0 = np.array([[5.], [3.0]], dtype=np.float64)


t0 = ds.t0
tf = ds.tf
h = ds.h    
no_inputs = ds.no_inputs    

output = 't'
[t, x, u] = rk_b.rk_back(sys.double_integrator, sys.input_calc1, t0, tf, h, no_inputs, x0, output)

if output == 't':
    plt.gca().invert_xaxis()
    plt.plot(t[0, :], x[0, :])
    plt.show()
elif output == 's':
    print(x)
