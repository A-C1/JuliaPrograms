x, y, p, q = var('x y p q')

eq1 = p + q == 9

eq2 = q*y + p*x == -6

eq3 = q*y^2 + p*x^2 == 24

a = solve([eq1, eq2, eq3, p==1], p, q, x, y) 
