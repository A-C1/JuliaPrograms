import math as mt
import numpy as np


def double_integrator_comp(tn, sn, un):

    """This function defines double integrator  and lambdas dynamics

    :tn: current time
    :sn: current state
    :un: current input
    :returns: returns the values of f(tn,sn,un)

    """

    x1 = sn[1, 0]
    x2 = un
    x3 = 0
    x4 = -sn[2, 0]

    x_o = np.array([[x1], [x2], [x3], [x4]], dtype=np.float64)

    return x_o


def dubins_vehicle(tn, sn, un):
    vel = 1
    x1 = vel*mt.cos(sn[2, 0])
    x2 = vel*mt.sin(sn[2, 0])
    x3 = un
    x_o = np.array([[x1], [x2], [x3]], dtype=np.float64)

    return x_o


def double_integrator(tn, sn, un):
    x1 = sn[1, 0]
    x2 = un
    x_o = np.array([[x1], [x2]], dtype=np.float64)

    return x_o


def input_double_integrator(lamda):
    if lamda[1, 0] < 0:
        return 1
    elif lamda[1, 0] > 0:
        return -1
    else:
        return 0

    pass


def input_calc1(xn):
    k = -1 * np.array([2.0, 3.0])
    u = k.dot(xn)
    return u


