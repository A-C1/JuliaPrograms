clc;
syms xe ye xp yp vp ve t ce se cp sp xc yc;
eq1 = xc - (xe + ve*t*ce);
eq2 = yc - (ye + ve*t*se);
eq3 = xc - (xp + vp*t*cp);
eq4 = yc - (yp + vp*t*sp);

eq5 = ce^2 + se^2 - 1;
eq6 = cp^2 + sp^2 - 1;

eq7 = yc*(xe-xp) + xc*(yp-ye) + (yp*xe-ye*xp);

eqns = [eq1==0, eq2 ==0, eq3 ==0, eq4==0,eq5==0,eq6==0, eq7==0];
S = solve(eqns, t, ce, se, cp, sp, xc, yc);
St = simplify(S.t);
subs(St,[vp ve xp yp xe ye],[2 1 0 0 1 0])
