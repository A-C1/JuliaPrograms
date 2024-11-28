function theta = solve_numerically(xp, up, yp, wp, xe, ue, ye, we)  
    global ap ae
    
%     syms t xc yc;
%   
%     
%     eq1 = (xc - xe - ue*t)^2 + (yc - ye - we*t)^2 - 0.5*ae^2*t^4;
%     eq2 = (xc - xp - up*t)^2 + (yc - yp - wp*t)^2  - 0.5*ap^2*t^4;
%     eq3 = yc*((up*t+xp) - (ue*t+xe)) + xc*(-(wp*t+yp) + (we*t+ye)) + (-(wp*t+yp)*(ue*t+xe)+(we*t+ye)*(up*t+xp));
% 
%     eqns = [eq1==0, eq2 ==0, eq3 ==0];
%     S = solve(eqns, [t, xc, yc]);

    
    syms  t ce se cp sp xc yc;


    eq1 = xc - xe - ue*t - 0.5*ae*t*t*ce;
    eq2 = yc - ye - we*t - 0.5*ae*t*t*se;
    eq3 = xc - xp - up*t - 0.5*ap*t*t*cp;
    eq4 = yc - yp - wp*t - 0.5*ap*t*t*sp;

    eq5 = ce^2 + se^2 - 1;
    eq6 = cp^2 + sp^2 - 1;

    eq7 = yc*((up*t+xp) - (ue*t+xe)) + xc*(-(wp*t+yp) + (we*t+ye)) + (-(wp*t+yp)*(ue*t+xe)+(we*t+ye)*(up*t+xp));

    eqns = [eq1==0, eq2 ==0, eq3 ==0, eq4==0,eq5==0,eq6==0, eq7==0];
    S = solve(eqns, [t, ce, se, cp, sp, xc, yc]);
    St = double(S.t)
    length(St)
    
    idx = 0;
    max_T = 0;
    for i=1:length(St)
        'hello'
        if abs(imag(St(i)))<= 1e-5 && St(i)>max_T
            idx = i
            max_T = real(St(i))
            'Hello'
        end
    end
    
    xc = double(real(S.xc(idx)))
    yc = double(real(S.yc(idx)))
    max_T

    theta_p = atan2((yc - yp - wp*max_T), (xc - xp - up*max_T))
    theta_e = atan2((yc - ye - we*max_T), (xc - xe - ue*max_T))
    theta = [theta_p theta_e]   
    
    err_e = double(S.xc(idx) - xe - ue*S.t(idx) - 0.5*ae*S.t(idx)*S.t(idx)*S.ce(idx))
    err_p = double(S.xc(idx) - xp - up*S.t(idx) - 0.5*ap*S.t(idx)*S.t(idx)*S.cp(idx))
end