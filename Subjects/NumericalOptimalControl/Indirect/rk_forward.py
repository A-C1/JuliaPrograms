import numpy as np
import math as mt


def rk_for(sys_dyn, input_calc, t0, tf, h, no_inputs, x0, output):
    no_iter = mt.ceil((tf - t0) / h)
    rows_x = np.size(x0)

    sn = x0
    tn = t0
    un = 0

    x = np.zeros((rows_x, no_iter), dtype=np.float64)
    t = np.zeros((1, no_iter), dtype=np.float64)
    u = np.zeros((no_inputs, no_iter), dtype=np.float64)

    for i in range(0, no_iter):
        x[:, i] = sn.T
        t[:, i] = tn
        u[:, i] = un

        un = input_calc(sn)

        k1 = h * sys_dyn(tn, sn, un)
        k2 = h * sys_dyn((tn + h / 2), (sn + k1 / 2), un)
        k3 = h * sys_dyn((tn + h / 2), (sn + k2 / 2), un)
        k4 = h * sys_dyn((tn + h), (sn + k3), un)

        sn += 1 / 6 * (k1 + 2 * k2 + 2 * k3 + k4)
        tn += h


    if output == 't':
        return t, x, u
    elif output == 's':
        return 0, sn, 0
