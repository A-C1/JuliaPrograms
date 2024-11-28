reset()

R.<xe, ye, xp, yp, vp, ve> = PolynomialRing(QQ)
F = R.fraction_field()
S.<t, ce, se, cp, sp, xc, yc> = PolynomialRing(F, order='lex')

eq1 = xc - (xe + ve*t*ce)
eq2 = yc - (ye + ve*t*se)
eq3 = xc - (xp + vp*t*cp)
eq4 = yc - (yp + vp*t*sp)

eq5 = ce^2 + se^2 - 1
eq6 = cp^2 + sp^2 - 1

eq7 = yc*(xp+xe) + xc*(yp+ye) - (yp*xe+ye*xp)



I = ideal(eq1, eq2, eq3, eq4, eq5, eq6, eq7)
B = I.groebner_basis()

print(B)


