from scipy.optimize import fsolve
import math

a = 1
b = 0
c = 4

def equations(p):
    x = p
    return (a*x*x + b*x + c)

x =  fsolve(equations, ([1, 2, 3, 4, 5, 6, 7]))

print(x)
