reset()

xc, yc, xe, ye, x1, y1, t, vp, ve, ce, se, c1, s1 = var('xc, yc, xe, ye, x1, y1, t, vp, ve, ce, se, c1, s1')
eq1 = xc == xe + ve*t*ce
eq2 = yc == ye + ve*t*se
eq3 = xc == x1 + vp*t*c1
eq4 = yc == y1 + vp*t*s1

eq5 = ce^2 + se^2 == 1
eq6 = c1^2 + s1^2 == 1

a = solve([eq1, eq2, eq3, eq4, eq5], xc, yc, t, ce, se, c1, s1)
print(a)
