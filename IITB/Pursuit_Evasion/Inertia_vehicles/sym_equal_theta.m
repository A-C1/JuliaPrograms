syms xe ye ue we a ax ay T 

eqn1 = (-xe + ue*T) + 0.5*ax*T^2 
eqn2 = (-ye + we*T) + 0.5*ay*T^2 
eqn3 = ax^2 + ay^2 -a^2

eqns = [eqn1 == 0, eqn2 ==0, eqn3==0]
S = solve(eqns,ax, ay, T)
% vars = [ce se T];
% g = gbasis(eqns, vars, 'MonomialOrder','lexicographic')