reset()

xc, yc, xe, ye, x1, y1, x2, y2, t, vp, ve, ce, se, c1, s1, c2, s2 = var('xc, yc, xe, ye, x1, y1, x2, y2, t, vp, ve, ce, se, c1, s1, c2, s2 ')
eq1 = xc == xe + ve*t*ce
eq2 = yc == ye + ve*t*se
eq3 = xc == x2 + vp*t*c2
eq4 = yc == y2 + vp*t*s2
eq5 = xc == x1 + vp*t*c1
eq6 = yc == y1 + vp*t*s1
eq_t1 = ce^2 + se^2 == 1
eq_t2 = c1^2 + s1^2 == 1
eq_t3 = c2^2 + s2^2 == 1
a = solve([eq1, eq2, eq3, eq4, eq5, eq6, eq_t1, eq_t2, eq_t3], xc, yc, t, ce, se, c1, s1, c2, s2)
print(a)
