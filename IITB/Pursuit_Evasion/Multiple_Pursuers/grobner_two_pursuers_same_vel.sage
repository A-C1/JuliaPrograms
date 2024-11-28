reset()

R.<xe, ye, x1, y1, x2, y2, v> = PolynomialRing(QQ)
F = R.fraction_field()
S.<xc, yc, t, ce, se, c1, s1, c2, s2 > = PolynomialRing(F)

eq1 = xc - (xe + v*t*ce)
eq2 = yc - (ye + v*t*se)
eq3 = xc - (x1 + v*t*c1)
eq4 = yc - (y1 + v*t*s1)
eq5 = xc - (x2 + v*t*c2)
eq6 = yc - (y2 + v*t*s2)

eq7 = ce^2 + se^2 - 1
eq8 = c1^2 + s1^2 - 1
eq9 = c2^2 + s2^2 - 1



I = ideal(eq1, eq2, eq3, eq4, eq5, eq6, eq7, eq8, eq9)
B = I.groebner_basis()

print(B)


