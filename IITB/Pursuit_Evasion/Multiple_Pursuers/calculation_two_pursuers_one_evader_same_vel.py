import numpy as np

x1 = -2
y1 = 0
x2 = 2
y2 = 0
x3 = -5
y3 = 0
xe = 0
ye = -0.25
v = 1

t = 3

xc = -(ye*x1**2 - xe**2*y1 - ye**2*y1 + ye*y1**2 - ye*x2**2 + y1*x2**2 + xe**2*y2 + ye**2*y2 - x1**2*y2 - y1**2*y2 -
       ye**y2**2 + y1*y2**2)/(-2*ye*x1 + 2*xe*y1 + 2*ye*x2 - 2*y1*x2 - 2*xe*y2 + 2*x1*y2)

yc = -(xe**2*x1 + ye**2*x1 - xe*x1**2 - xe*y1**2 - xe**2*x2 - ye**2*x2 + x1**2*x2 + y1**2*x2 + xe*x2**2 - x1*x2**2 +
       xe*y2**2 - x1*y2**2)/(-2*ye*x1 + 2*xe*y1 + 2*ye*x2 - 2*y1*x2 - 2*xe*y2 + 2*x1*y2)

theta = np.arctan2(yc-y1, xc-x1)
x1_t = v*t*np.cos(theta) 
y1_t = v*t*np.sin(theta) 

x2_t = x2 - v*t*np.cos(theta) 
y2_t = v*t*np.sin(theta) 

xe_t = xe
ye_t = ye + v*t

x3_t = x3
y3_t = y3 + v*t

print(yc, xc)
print(xe_t, ye_t)
print(x1_t, y1_t)
print(x2_t, y2_t)
print(x3_t, y3_t)
