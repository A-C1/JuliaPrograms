reset()

R.<xe, ye, x1, y1, x2, y2, vp, ve> = PolynomialRing(QQ,order='degrevlex')
F = R.fraction_field()
S.<xc, yc, t, ce, se, c1, s1, c2, s2 > = PolynomialRing(F, order='degrevlex')

eq1 = xc - (xe + ve*t*ce)
eq2 = yc - (ye + ve*t*se)
eq3 = xc - (x1 + vp*t*c1)
eq4 = yc - (y1 + vp*t*s1)
eq5 = xc - (x2 + vp*t*c2)
eq6 = yc - (y2 + vp*t*s2)

eq7 = ce^2 + se^2 - 1
eq8 = c1^2 + s1^2 - 1
eq9 = c2^2 + s2^2 - 1



I = ideal(eq1, eq2, eq3, eq4, eq5, eq6, eq7, eq8, eq9)
B = I.groebner_basis()

print(B)


