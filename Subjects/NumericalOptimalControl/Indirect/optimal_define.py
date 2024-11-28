import numpy as np


def h(x, lamda, u):
    return 1 + lamda[0, 0] * x[1, 0] + lamda[1, 0] * u


def phi(x, neu):
    return neu[0, 0] * x[0, 0] + neu[1, 0] * x[1, 0]


def psi(x):
    return np.array([[x[0, 0]], [x[1, 0]]])


def omega(x, u, neu):
    return neu[0, 0] * x[1, 0] + neu[1, 0] * u
